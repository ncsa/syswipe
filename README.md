# Syswipe
Tools to scrub disks and factory reset 
a server when it is decommissioned.

# Create bootable USB key
### Get System Rescue CD image
* [Burn a USB key](https://www.system-rescue.org/Installing-SystemRescue-on-a-USB-memory-stick/)

### Configure on Linux (or Bash on Windows)
* cd to the USB key root
* `curl
  "https://raw.githubusercontent.com/ncsa/syswipe/${SYSWIPE_GIT_BRANCH:-main}/setup_srcd.sh"
  | bash`

# Auto wipe a Dell System
1. ssh to the system
1. If not already installed, install racadm
   ```
   curl -s https://linux.dell.com/repo/hardware/dsu/bootstrap.cgi | bash
   yum install -y srvadmin-idracadm7
   mkdir /root/bin
   ln -s /opt/dell/srvadmin/bin/idracadm7 /root/bin/racadm
   ```
1. `racadm systemerase idrac,bios`
2. Node will reboot on it's own and usually will stay off
3. Insert USB key
4. Power on node
   1. If there are remaining iDRAC changes to apply, it will apply those and power off again.
   2. Repeat until it boots from USB, which will auto wipe all the drives.
  

# Extras
## Enable USB boot on Dell server
* `curl
  "https://raw.githubusercontent.com/ncsa/syswipe/${SYSWIPE_GIT_BRANCH:-main}/scripts/Dell/racadm_set_usb_boot"
  | bash`
