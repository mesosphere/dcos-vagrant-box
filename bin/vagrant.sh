#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo '>>> Saving box build time'
date > /etc/vagrant_box_build_time

echo '>>> Installing default vagrant ssh key'
mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo '>>> Modifying sshd_config to speedup login'
sshd_config='/etc/ssh/sshd_config'
for keyword in UseDNS GSSAPIAuthentication; do
  if grep -q -E "^[[:space:]]*${keyword}" "${sshd_config}"; then
    sed -i "s/^\s*${keyword}.*/${keyword} no/" "${sshd_config}"
  else
    echo "${keyword} no" >> "${sshd_config}"
  fi
done
