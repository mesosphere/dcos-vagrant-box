#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# enable interruption signal handling
trap - INT TERM

docker run --rm \
	-t $(tty &>/dev/null && echo "-i") \
	-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
	-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
	-v "$(pwd):/project" \
	mesosphere/aws-cli \
	$@
