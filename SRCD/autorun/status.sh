#!/bin/bash

#
# PREP
#
. /root/wipe_lib


#
# FUNCTIONS
#
get_valid_devs() {
  # if TRAN is null, then it's a partition or virtual device
  lsblk -o kname,tran,type --paths --json \
  | jq -r '.blockdevices[] 
    | select(.type == "disk" and .tran != null )
    | .kname'
}


#
# DO WORK
#

devices=( $(get_valid_devs) )
if [[ ${#devices[*]} -lt 1 ]] ; then
  die "No wipeable devices found"
fi

# Show what drives were found
info "Found ${#devices[*]} device(s) ..."
lsblk "${devices[@]}" \
  | grep '^[a-zA-Z]' \
  | tee -a "$LOGFILE"

# Status for each drive
# set -x
table_fmt="%-10s %-15s %-10s %-9s %-15s\n"
printf "$table_fmt" ""    ""     ""     "%"        "seconds"
printf "$table_fmt" "dev" "size" "rate" "complete" "remaining"
for dev in "${devices[@]}"; do
  size=$( get_dev_size "$dev" )
  rate=$( get_write_rate "$dev" )
  if [[ $rate -lt 1000 ]]; then
    # short circuit device that isn't wiping
    printf "$table_fmt" "$dev" "$size" "$rate" "-" "-"
    continue
  fi
  sofar=$( get_written_sofar "$dev" )
  num_passes=2 #this should move to write_lib and be used throughout all scripts
  bytes_total=$( bc <<< "$size * $num_passes" )
  bytes_remaining=$( bc <<< "$bytes_total - $sofar" )
  seconds_remaining=$( bc <<< "$bytes_remaining / $rate" )
  percent_complete=$( bc <<< "$sofar * 100 / $bytes_total" )
  printf "$table_fmt" "$dev" "$size" "$rate" "$percent_complete" "$seconds_remaining"
done
