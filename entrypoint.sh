#!/bin/bash
set -e

# Generate MASTER_PASSWORD if not already set
if [ -z "$MASTER_PASSWORD" ]; then
    export MASTER_PASSWORD=$(pwgen -y -s 32 1)
    echo "Generated MASTER_PASSWORD: $MASTER_PASSWORD"
else
    echo "Using existing MASTER_PASSWORD"
fi

# Validate OPENDESK_VERSION format
if ! [[ "$OPENDESK_VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: OPENDESK_VERSION must match format vX.Y.Z (e.g., v1.9.0)"
    exit 1
fi

# Download and extract opendesk archive
OPENDESK_URL="https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/archive/${OPENDESK_VERSION}/opendesk-${OPENDESK_VERSION}.tar.bz2"
OPENDESK_DIR="/workspace/opendesk"

echo "Downloading opendesk ${OPENDESK_VERSION}..."
if ! curl -L --fail --retry 3 --retry-delay 2 "${OPENDESK_URL}" -o /tmp/opendesk.tar.bz2; then
    echo "Error: Failed to download opendesk ${OPENDESK_VERSION}"
    exit 1
fi

echo "Extracting opendesk archive..."
mkdir -p "${OPENDESK_DIR}"
tar -xjf /tmp/opendesk.tar.bz2 -C "${OPENDESK_DIR}" --strip-components=1
rm /tmp/opendesk.tar.bz2

echo "Opendesk ${OPENDESK_VERSION} successfully extracted to ${OPENDESK_DIR}"

cd "${OPENDESK_DIR}"

# Execute the provided command or default CMD
exec "$@"
