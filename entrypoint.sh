#!/bin/bash
set -e

# Download and extract opendesk archive
OPENDESK_URL="https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/archive/${OPENDESK_VERSION}/opendesk-${OPENDESK_VERSION}.tar.bz2"
OPENDESK_DIR="/workspace/opendesk"

echo "Downloading opendesk ${OPENDESK_VERSION}..."
curl -L "${OPENDESK_URL}" -o /tmp/opendesk.tar.bz2

echo "Extracting opendesk archive..."
mkdir -p "${OPENDESK_DIR}"
tar -xjf /tmp/opendesk.tar.bz2 -C "${OPENDESK_DIR}" --strip-components=1
rm /tmp/opendesk.tar.bz2

echo "Opendesk ${OPENDESK_VERSION} successfully extracted to ${OPENDESK_DIR}"

# Execute the provided command or default CMD
exec "$@"
