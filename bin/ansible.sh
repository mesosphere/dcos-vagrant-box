#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Instructions from https://flatpacklinux.com/2016/05/27/install-ansible-2-1-on-rhelcentos-7-with-pip/

echo '>>> Installing yum-utils'
yum install -y yum-utils

# Add the EPEL repository, and install Ansible.
echo '>>> Adding EPEL yum repo'
yum-config-manager --add-repo=https://dl.fedoraproject.org/pub/epel/7/x86_64/
curl --fail --location --silent --show-error --verbose -o /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

echo '>>> Cleaning yum cache'
yum clean all

echo '>>> Installing pip (and dependencies)'
yum install -y python-devel libffi-devel openssl-devel gcc python-pip redhat-rpm-config

echo '>>> Upgrading pip'
pip install --upgrade pip==19.1.1

# Avoid bug in default python cryptography library
# [WARNING]: Optional dependency 'cryptography' raised an exception, falling back to 'Crypto'
echo '>>> Upgrading python cryptography library'
pip install --upgrade cryptography

echo '>>> Installing Ansible'
pip install ansible==2.8.1
