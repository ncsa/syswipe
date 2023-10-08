# Syswipe
Tools to scrub disks and factory reset 
a server when it is decommissioned.

# Create bootable USB key
### Get System Rescue CD image
* [Burn a USB key](https://www.system-rescue.org/Installing-SystemRescue-on-a-USB-memory-stick/)

### Configure on Linux (or Bash on Windows)
* cd to the USB key root
* (OPTIONAL) Use a branch other than main
  * `export SYSWIPE_GIT_BRANCH=some_branch_name`
* `curl
  "https://raw.githubusercontent.com/ncsa/syswipe/${SYSWIPE_GIT_BRANCH:-main}/setup_srcd.sh"
  | bash`

# Auto wipe a server
### Boot from USB key
1. Insert USB key
1. Power on (or reboot)
1. If boot from USB is not enabled:
   1. During POST, manually select Boot options (usually F11)
   1. Select the USB key as the boot option

### Monitor wipe progress
Auto-wipe of all local drives is run on terminal 2. Monitor progress by
switching to terminal 2:
1. `Ctl-Alt-F2`


# Continuous wipe using an external drive carrier
Connect a USB drive carrier and insert a hard drive.

The system will detect the new device and wipe it automatically.

When it's complete, swap in a new drive to have it auto-wiped.

Repeat until all drives are wiped.
### Monitor wipe progress
Auto-wipe of hot-swap drives is run on terminal 3. Monitor progress by
switching to terminal 3:
1. `Ctl-Alt-F3`


# Other tools
## Wipe a Dell System iDRAC - BEFORE doing auto-wipe
1. ssh to the system
1. If not already installed, install racadm
   ```
   curl -s https://linux.dell.com/repo/hardware/dsu/bootstrap.cgi | bash
   yum install -y srvadmin-idracadm7
   mkdir /root/bin
   ln -s /opt/dell/srvadmin/bin/idracadm7 /root/bin/racadm
   ```
1. `racadm systemerase idrac,bios`
1. Node will reboot on it's own and usually will stay off
1. Insert USB key
1. Power on node
   1. If there are remaining iDRAC changes to apply, it will apply those and power off again.
   1. Repeat until it boots from USB, which will auto wipe all the drives.
  

# Extras
## Enable USB boot on Dell server
* `curl
  "https://raw.githubusercontent.com/ncsa/syswipe/${SYSWIPE_GIT_BRANCH:-main}/scripts/Dell/racadm_set_usb_boot"
  | bash`

# See also
* https://github.com/andylytical/autonuke
