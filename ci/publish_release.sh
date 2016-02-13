#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ -z "${BOX_VERSION}" ]; then
  echo "BOX_VERSION must be set" >&2
  exit 1
fi

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)

BOX_NAME=dcos-centos-virtualbox-${BOX_VERSION}

echo "Checking out build branch: ${BOX_NAME}"
cd "${project_dir}"
git checkout ${BOX_NAME}
git pull origin ${BOX_NAME}

if ! grep -q "${BOX_NAME}.box" "${project_dir}/metadata.json"; then
  echo "metadata.json does not include ${BOX_NAME}.box" >&2
  exit 1
fi

echo "Building mesosphere/aws-cli"
cd "${project_dir}/aws-cli"
docker build -t mesosphere/aws-cli .

echo "Uploading metadata.json"
cd "${project_dir}"
aws-cli/aws.sh s3 cp metadata.json s3://downloads.mesosphere.io/dcos-vagrant/ --content-type "application/json"

echo "Checking out master branch"
git checkout master
git pull origin master

echo "Merging build branch to master"
git merge ${BOX_NAME} --no-ff -m "Publish release: ${BOX_NAME}"
git push origin master

echo "Deleting build branch"
git branch -D ${BOX_NAME}
git push origin --delete ${BOX_NAME}

echo "Creating tag"
git tag -a v${BOX_VERSION} -m "Version ${BOX_VERSION}"
git push origin v${BOX_VERSION}
