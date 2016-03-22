#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo ">>> Installing packages required by DCOS installer"
# See https://github.com/mesosphere/dcos-image/blob/master/providers/bash.py
yum install --assumeyes --tolerant curl bash ping tar xz unzip ipset

echo ">>> Installing net-tools (for debugging)"
yum install --assumeyes --tolerant net-tools

echo ">>> Caching docker image: jplock/zookeeper"
docker pull jplock/zookeeper

echo ">>> Caching docker image: nginx"
docker pull nginx

echo ">>> Caching docker image: registry"
docker pull registry:2

echo ">>> Disabling firewalld"
# docker/firewalld conflict: https://github.com/docker/docker/issues/16137
systemctl stop firewalld
systemctl disable firewalld

echo ">>> Creating ~/dcos"
mkdir -p ~/dcos && cd ~/dcos
