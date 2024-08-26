# Configure SRCD for wiping disks
REPO="https://raw.githubusercontent.com/ncsa/syswipe"
BRANCH=${SYSWIPE_GIT_BRANCH:-main}


die() {
  echo "ERROR: $*" 1>&2
  exit 1
}


install_files() {
  [[ -d "$DIR" ]] || die "Directory not found '$DIR'"
  pushd "$DIR"
  for fn in "${SOURCES[@]}" ; do
    curl -O "$REPO/$BRANCH/SRCD/$DIR/$fn"
  done
  popd
}

# YAML config files go in sysrescue.d
# to be read in on SRCD boot
# Keep the list of files accurate with `ls SRCD/sysrescue.d`
DIR=sysrescue.d
SOURCES=(
  200-custom.yaml
)
install_files

# Put all other files in autorun so they are accessible on the live instance
# The "install" script will be invoked during autorun and
# will move things to /root for easier access
# Keep the list of files accurate with `ls SRCD/autorun`
DIR=autorun
SOURCES=(
99_detect_new_disk.rules
add_disk_to_wipe.sh
auto_wipe.sh
continuous_wipe.sh
install_wiping_scripts.sh
status.sh
wipe_lib
wipe_next.sh
)
install_files

# Add authorized_keys for remote login
TGT=sysrescue.d/201-authorized_keys.yaml
if [[ -n $SYSWIPE_AUTHKEYS_GITHUBUSER ]] ; then
  >"$TGT" cat <<ENDHERE
---
global:
  nofirewall: true
sysconfig:
  authorized_keys:
ENDHERE
  URL=https://github.com/${SYSWIPE_AUTHKEYS_GITHUBUSER}.keys
  curl -s "$URL" \
  | awk -v "user=$SYSWIPE_AUTHKEYS_GITHUBUSER" -e '
      {printf("    \"%d-github.com/%s\": \"%s\"\n", NR, user, $0)}
    ' \
  >>"$TGT"
fi
