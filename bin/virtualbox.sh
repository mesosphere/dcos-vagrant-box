#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo ">>> Installing packages required by VBoxGuestAdditions"
# https://github.com/dotless-de/vagrant-vbguest/blob/master/lib/vagrant-vbguest/installers/redhat.rb
yum install --assumeyes --tolerant kernel-devel-$(uname -r) gcc binutils make perl bzip2

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)

echo ">>> Installing VBoxGuestAdditions ${VBOX_VERSION}"
cd /tmp
mount -o loop /home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
# TODO: fix OpenGL support module installation
sh /mnt/VBoxLinuxAdditions.run || true
umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso
