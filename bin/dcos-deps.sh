#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo ">>> Installing packages required by DCOS installer"
# See https://github.com/mesosphere/dcos-image/blob/master/providers/bash.py
yum install --assumeyes --tolerant curl bash ping tar xz unzip

echo ">>> Installing net-tools (for debugging)"
yum install --assumeyes --tolerant net-tools

echo ">>> Caching docker image: jplock/zookeeper"
docker pull jplock/zookeeper

echo ">>> Caching docker image: nginx"
docker pull nginx

echo ">>> Disabling firewalld"
systemctl stop firewalld
systemctl disable firewalld

echo ">>> Creating ~/dcos"
mkdir -p ~/dcos && cd ~/dcos
