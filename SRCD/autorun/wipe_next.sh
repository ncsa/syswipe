#!/usr/bin/bash

. /root/wipe_lib

[[ $DEBUG -gt 0 ]] && set -x

# If DEVICES_FILE has a disk name in it, wipe that disk
kname=$( head -1 "${DEVICES_FILE}" )
if [[ -n "${kname}" ]] ; then
  if try_lock ; then
    TMP=$(mktemp)
    echo "${kname}" > "$TMP"
    mv "${TMP}" "${LOCK_FILE}"
    tail -n+2 "${DEVICES_FILE}" > $TMP
    mv $TMP "${DEVICES_FILE}"
    wipe_device "${kname}"
    release_lock
    [[ -f $TMP ]] && rm $TMP
  fi
fi
