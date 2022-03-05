# Syswipe
Tools to scrub disks and factory reset 
a server when it is decommissioned.


## Get System Rescue CD image
* [Burn a USB key](https://www.system-rescue.org/Installing-SystemRescue-on-a-USB-memory-stick/)

## Configure on Linux (or Bash on Windows)
* cd to the USB key root
* `curl
  "https://raw.githubusercontent.com/ncsa/syswipe/${SYSWIPE_GIT_BRANCH:-main}/setup_srcd.sh"
  | bash`

## Enable USB boot on Dell server
* curl
  "https://raw.githubusercontent.com/ncsa/syswipe/${SYSWIPE_GIT_BRANCH:-main}/scripts/Dell/racadm_set_usb_boot"
  | bash
