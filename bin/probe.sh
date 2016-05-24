#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo '>>> Installing probe'

WORK_DIR="$(mktemp -d)"
trap "rm -rf '${WORK_DIR}'" EXIT

cd "${WORK_DIR}"

PROBE_ARCHIVE_URL="https://github.com/karlkfi/probe/releases/download/v0.3.0/probe-0.3.0-linux_amd64.tgz"
PROBE_ARCHIVE_NAME="$(basename "${PROBE_ARCHIVE_URL}")"

curl --fail --location --silent --show-error --output "${PROBE_ARCHIVE_NAME}" "${PROBE_ARCHIVE_URL}"

cat << EOF > "checksums"
5e12339fa770b58ca7b7c4291927390d0ad9f61e6cf95e2572c5de5a7a8db0ec *${PROBE_ARCHIVE_NAME}
EOF

if ! sha256sum -c "checksums" --status; then
  >&2 echo "Invalid archive checksum"
  exit 1
fi

tar -zxf "${PROBE_ARCHIVE_NAME}" --directory "/usr/local/sbin/"
