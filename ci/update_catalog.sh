#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ -z "${BOX_VERSION}" ]; then
  echo "BOX_VERSION must be set" >&2
  exit 1
fi

if [ -z "${BOX_DESC}" ]; then
  echo "BOX_DESC must be set" >&2
  exit 1
fi

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)

BOX_NAME=dcos-centos-virtualbox-${BOX_VERSION}

if [ ! -f "${BOX_NAME}.box" ]; then
  echo "Box not found: ${BOX_NAME}.box" >&2
  exit 1
fi

if grep -q "${BOX_NAME}.box" "${project_dir}/metadata.json"; then
  echo "Catalog already includes ${BOX_NAME}.box" >&2
  exit 1
fi

echo "Generating checksum"
CHECKSUM=$(openssl sha1 "${BOX_NAME}.box" | cut -d ' ' -f 2)

echo "Creating git branch: ${BOX_NAME}"
git checkout -b ${BOX_NAME}

echo "Updating catalog"
docker run --rm \
  -t $(tty &>/dev/null && echo "-i") \
  -v "${project_dir}:/project" \
  karlkfi/atlas-meta \
  --repo '/project/metadata.json' \
  --version "${BOX_VERSION}" \
  --status 'active' \
  --desc "${BOX_DESC}" \
  --provider 'virtualbox' \
  --box "https://downloads.dcos.io/dcos-vagrant/${BOX_NAME}.box" \
  --checksum-type sha1 \
  --checksum "${CHECKSUM}" \
  add

echo "Pushing metadata.json changes to branch"
git add "${project_dir}/metadata.json"
git commit -m "Add to catalog: ${BOX_NAME}"
git push origin ${BOX_NAME}
