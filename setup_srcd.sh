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

# # Install custom boot options
# src_fn="config/grub/custom.cfg"
# tgt_fn="boot/grub/custom.cfg"
# curl -o "$tgt_fn" "$REPO/$BRANCH/$src_fn"
