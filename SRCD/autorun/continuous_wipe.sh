#!/usr/bin/bash

PRG="$(basename $0)"

# Import useful functions
. /root/wipe_lib

[[ $DEBUG -gt 0 ]] && set -x

while /bin/true ; do
  dt="$(datetime)"
  echo "${dt} ${PRG} wakeup"
  if [[ -f "${LOCK_FILE}" ]] ; then
    echo -n "  Wipe in progress ... "
    cat "${LOCK_FILE}"
  else
    /root/wipe_next.sh
  fi
  echo "  ... sleep"
  sleep 60
done
