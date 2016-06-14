#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo '>>> Adding docker yum repo'
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

echo '>>> Installing packages (docker)'
yum install --assumeyes --tolerant docker-engine

echo '>>> Stopping docker (to reconfigure)'
systemctl stop docker

echo '>>> Removing docker volumes (/var/lib/docker)'
rm -rf /var/lib/docker

echo '>>> Configuring docker (OverlayFS)'
sed -i -e '/^ExecStart=/ s/$/ --storage-driver=overlay/' /usr/lib/systemd/system/docker.service

echo '>>> Creating docker group and adding vagrant user to it'
/usr/sbin/groupadd -f docker
/usr/sbin/usermod -aG docker vagrant

echo '>>> Enabling docker on boot'
systemctl enable docker

echo '>>> Starting docker'
systemctl start docker

echo '>>> Disabling SELinux and adjusted sudoers'
sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config
sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers

function systctl_set() {
  key=$1
  value=$2
  config_path='/etc/sysctl.conf'
  # set now
  sysctl -w ${key}=${value}
  # persist on reboot
  if grep -q "${key}" "${config_path}"; then
    sed -i "s/^${key}.*$/${key} = ${value}/" "${config_path}"
  else
    echo "${key} = ${value}" >> "${config_path}"
  fi
}

echo '>>> Disabling IPv6'
systctl_set net.ipv6.conf.all.disable_ipv6 1
systctl_set net.ipv6.conf.default.disable_ipv6 1

echo '>>> Enabling IPv4 Forwarding'
systctl_set net.ipv4.ip_forward 1
