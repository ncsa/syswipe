# Configure SRCD for wiping disks
REPO="https://raw.githubusercontent.com/ncsa/syswipe"
BRANCH=${SYSWIPE_GIT_BRANCH:-main}

# Install autorun (wipe script)
src_fn="scripts/SRCD/wipe_shred"
tgt_fn="autorun/autorun0"
curl -o "$tgt_fn" "$REPO/$BRANCH/$src_fn"

# Install custom SRCD config
src_fn="config/SRCD/200-custom.yaml"
tgt_fn="sysrescue.d/200-custom.yaml"
curl -o "$tgt_fn" "$REPO/$BRANCH/$src_fn"

# Set grub timeout to 1 
# Set grub default boot menu to 3 (nomodeset)
#   - apparently can't put nomodeset in the yaml config file
sed --in-place=orig \
  -e '/^set timeout=/c set timeout=1' \
  -e '/^set default=/c set default=3' \
  boot/grub/grubsrcd.cfg
