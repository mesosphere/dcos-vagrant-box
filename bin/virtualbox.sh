#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo ">>> Installing packages required by VBoxGuestAdditions"
# https://github.com/dotless-de/vagrant-vbguest/blob/master/lib/vagrant-vbguest/installers/redhat.rb
yum install --assumeyes --tolerant kernel-devel-$(uname -r) gcc binutils make perl bzip2
