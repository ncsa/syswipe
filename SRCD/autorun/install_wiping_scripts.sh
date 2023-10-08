#!/usr/bin/bash

set -x

AUTORUN=/run/archiso/bootmnt/autorun

# udev rules
mv "${AUTORUN}"/*.rules /etc/udev/rules.d/.

# root scripts
cp "${AUTORUN}"/*.sh /root/.
cp "${AUTORUN}"/*lib /root/.
