# Configure SRCD for wiping disks
REPO="https://raw.githubusercontent.com/ncsa/syswipe"
BRANCH=${SYSWIPE_GIT_BRANCH:-main}

# Install autorun (wipe script)
src_fn="scripts/SRCD/wipe_all_drives"
pushd "autorun"
curl -O "$REPO/$BRANCH/$src_fn"
popd

# Install custom SRCD config
src_fn="config/SRCD/200-custom.yaml"
pushd "sysrescue.d"
curl -O "$REPO/$BRANCH/$src_fn"
popd

# # Install custom boot options
# src_fn="config/grub/custom.cfg"
# tgt_fn="boot/grub/custom.cfg"
# curl -o "$tgt_fn" "$REPO/$BRANCH/$src_fn"
