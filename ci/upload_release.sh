#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ -z "${BOX_VERSION}" ]; then
  echo "BOX_VERSION must be set" >&2
  exit 1
fi

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)

echo "Building mesosphere/aws-cli"
cd "${project_dir}/aws-cli"
docker build -t mesosphere/aws-cli .

echo "Uploading dcos-centos-virtualbox-${BOX_VERSION}.box"
cd "${project_dir}"
aws-cli/aws.sh s3 cp dcos-centos-virtualbox-${BOX_VERSION}.box s3://downloads.dcos.io/dcos-vagrant/
