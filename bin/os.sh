#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# caching doesn't speed up one-time installation
# yum makecache fast

echo ">>> Old Kernel: $(uname -r)"
echo '>>> Upgrading OS'
yum upgrade --assumeyes --tolerant
yum update --assumeyes
echo ">>> New Kernel: $(uname -r)"

if ! lsmod | grep -q overlay; then
  echo '>>> Enabling OverlayFS on boot'
  echo 'overlay' > /etc/modules-load.d/overlay.conf
fi

echo '>>> Rebooting to upgrade kernel'
reboot
