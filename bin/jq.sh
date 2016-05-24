#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo ">>> Installing jq"

WORK_DIR="$(mktemp -d)"
trap "rm -rf '${WORK_DIR}'" EXIT

cd "${WORK_DIR}"

JQ_BINARY_URL="https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64"
JQ_BINARY_NAME="$(basename "${JQ_BINARY_URL}")"

curl --fail --location --silent --show-error --output "${JQ_BINARY_NAME}" "${JQ_BINARY_URL}"

cat << EOF > "checksums"
c6b3a7d7d3e7b70c6f51b706a3b90bd01833846c54d32ca32f0027f00226ff6d *${JQ_BINARY_NAME}
EOF

if ! sha256sum -c "checksums" --status; then
  >&2 echo "Invalid executable checksum"
  exit 1
fi

mv "${JQ_BINARY_NAME}" "/usr/local/sbin/jq"
chmod a+x "/usr/local/sbin/jq"
