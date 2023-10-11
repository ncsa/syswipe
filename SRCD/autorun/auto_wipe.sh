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
  # if TRAN is usb, then it's a USB device (dont wipe the boot USB key)
  lsblk -o kname,tran,type --paths --json \
  | jq -r '.blockdevices[] 
    | select(.type == "disk" and .tran != null and .tran != "usb")
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

# Wipe all the drives
for dev in "${devices[@]}"; do
  wipe_device "${dev}" || warn "Wipe failed for '${dev}'" &
done

# wait for all the "shred" procs to finish
wait

info "Done. Wiped ${#devices[*]} device(s) in ${SECONDS} seconds"

exit 0
