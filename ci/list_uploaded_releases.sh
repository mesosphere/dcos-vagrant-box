#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)
cd "${project_dir}"

echo "Listing contents of bucket: s3://downloads.dcos.io/dcos-vagrant/"
export AWS_DEFAULT_REGION=us-west-2
ci/aws.sh s3 ls s3://downloads.dcos.io/dcos-vagrant/
