# Syswipe
Tools to scrub disks and factory reset 
a server when it is decommissioned.

# Create bootable USB key
### Get System Rescue CD image
* [Burn a USB key](https://www.system-rescue.org/Installing-SystemRescue-on-a-USB-memory-stick/)

### Configure on Linux (or [Bash on Windows](https://gitforwindows.org/))
* cd to the USB key root
* (optional, set additional environment variables ... see "Advanced Install"
  below)
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
### Monitor progress of auto-wipe local drives
* Live: `Ctl-Alt-F2`
* Logs: `/var/log/auto_wipe.log`
* Live Rate: `iostat -z -m -y -d 1 1`


# Continuous wipe using an external drive carrier
Connect a USB drive carrier and insert a hard drive.
The system will detect the new device and wipe it automatically.
When it's complete, swap in a new drive to have it auto-wiped.
Repeat until all drives are wiped.
### Monitor progress of hot-swap drive wipes
* Live: `Ctl-Alt-F3`
* Monitor: `watch -n 30 /root/status.sh`
* Logs: `/var/log/continous_wipe.log`
* Live Rate: `iostat -p "$(cat /root/disk_wipe_in_progress)" -m -y -d 1 1`


# Advanced Install Options - Environment Variables
Control extra features during "Configure" stage.

Set these before running "curl ... setup_srcd.sh" (above)
* Use a branch other than main
  * `export SYSWIPE_GIT_BRANCH=some_branch_name`
* Install ssh authorized_keys from github.com/user.keys
  * `export SYSWIPE_AUTHKEYS_GITHUBUSER=githubusername`

### Reset customizations
1. Insert USB key
1. cd to the USB key root
1. `rm -f autorun/* sysrescue.d/2*`


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
