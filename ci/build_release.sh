#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ -z "${BOX_VERSION}" ]; then
  echo "BOX_VERSION must be set" >&2
  exit 1
fi

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)

PACKER="$(which packer || true)"
if [ -z "${PACKER}" ]; then
  echo "Packer must be installed and on the PATH" >&2
  exit 1
fi

echo "Building dcos-centos-virtualbox-${BOX_VERSION}.box"
cd "${project_dir}"
"${PACKER}" build packer-template.json
mv dcos-centos-virtualbox.box dcos-centos-virtualbox-${BOX_VERSION}.box
