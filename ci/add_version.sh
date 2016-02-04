#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ -z "${BOX_VERSION}" ]; then
  echo "BOX_VERSION must be set" >&2
  exit 1
fi

if [ -z "${BOX_FILE}" ]; then
  echo "BOX_FILE must be set" >&2
  exit 1
fi

if [ -z "${BOX_DESC}" ]; then
  echo "BOX_DESC must be set" >&2
  exit 1
fi

build_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)

if grep -q "dcos-centos-virtualbox-${BOX_VERSION}.box" "${build_dir}/metadata.json"; then
  echo "metadata.json already includes dcos-centos-virtualbox-${BOX_VERSION}.box" >&2
  exit 1
fi

echo "Generating checksum"
CHECKSUM=$(openssl sha1 "${BOX_FILE}" | cut -d ' ' -f 2)

echo "Updating metadata.json"
docker run --rm -it \
  -v "${build_dir}:/build" \
  karlkfi/atlas-meta \
  --repo '/build/metadata.json' \
  --version "${BOX_VERSION}" \
  --status 'active' \
  --desc "${BOX_DESC}" \
  --provider 'virtualbox' \
  --box "https://s3-us-west-1.amazonaws.com/dcos-vagrant/dcos-centos-virtualbox-${BOX_VERSION}.box" \
  --checksum-type sha1 \
  --checksum "${CHECKSUM}" \
  add

echo "Pushing metadata.json changes"
git add "${build_dir}/metadata.json"
git commit -m "Add box version: ${BOX_VERSION}"
git push
