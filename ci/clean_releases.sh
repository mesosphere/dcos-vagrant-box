#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

build_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)

cd "${build_dir}"

rm -fv dcos-centos-virtualbox-*.box
