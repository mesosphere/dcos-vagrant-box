#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ -z "${BOX_VERSION}" ]; then
  echo "BOX_VERSION must be set" >&2
  exit 1
fi

build_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)

if ! grep -q "dcos-centos-virtualbox-${BOX_VERSION}.box" "${build_dir}/metadata.json"; then
  echo "metadata.json does not include dcos-centos-virtualbox-${BOX_VERSION}.box" >&2
  exit 1
fi

echo "Building mesosphere/aws-cli"
cd "${build_dir}/aws-cli"
docker build -t mesosphere/aws-cli .

echo "Uploading metadata.json"
aws-cli/aws.sh s3 cp metadata.json s3://dcos-vagrant/ --content-type "application/json"
