#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo ">>> Cleaning yum"
yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all

echo ">>> Cleaning VBoxGuestAdditions"
rm -rf VBoxGuestAdditions_*.iso

echo ">>> Cleaning Ruby Gems"
rm -rf /tmp/rubygems-*

echo ">>> Cleaning Network Interfaces"
rm -f /etc/udev/rules.d/70-persistent-net.rules;
mkdir -p /etc/udev/rules.d/70-persistent-net.rules;
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules;
rm -rf /dev/.udev/;

echo ">>> Disabling NetworkManager"
for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
  if [ "$(basename ${ndev})" != "ifcfg-lo" ]; then
    # clear MAC address
    sed -i '/^HWADDR/d' "${ndev}";
    # clear interface UID so it's regenerated for each new VM
    sed -i '/^UUID/d' "${ndev}";
    # disable NetworkManager
    echo "NM_CONTROLLED=no" | tee --append "${ndev}" > /dev/null
  fi
done
