#!/bin/bash
set -e

# Validate ENVIRONMENT is set
if [ -z "$ENVIRONMENT" ]; then
    echo "Error: ENVIRONMENT variable is not set"
    exit 1
fi
echo "Using ENVIRONMENT: $ENVIRONMENT"

# Validate NAMESPACE is set
if [ -z "$NAMESPACE" ]; then
    echo "Error: NAMESPACE variable is not set"
    exit 1
fi
echo "Using NAMESPACE: $NAMESPACE"


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

OPENDESK_DIR="/workspace/opendesk"

mkdir -p "${OPENDESK_DIR}"
cd "${OPENDESK_DIR}"

# Git clone opendesk repository from https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/ and checkout version ${OPENDESK_VERSION}
echo "Cloning opendesk repository..."
if ! git clone https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk.git .; then
    echo "Error: Failed to clone opendesk repository"
    exit 1
fi
echo "Checking out version ${OPENDESK_VERSION}..."
if ! git checkout "${OPENDESK_VERSION}"; then
    echo "Error: Failed to checkout version ${OPENDESK_VERSION}"
    exit 1
fi

# # Download and extract opendesk archive
# OPENDESK_URL="https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/archive/${OPENDESK_VERSION}/opendesk-${OPENDESK_VERSION}.tar.bz2"

# echo "Downloading opendesk ${OPENDESK_VERSION}..."
# if ! curl -L --fail --retry 3 --retry-delay 2 "${OPENDESK_URL}" -o /tmp/opendesk.tar.bz2; then
#     echo "Error: Failed to download opendesk ${OPENDESK_VERSION}"
#     exit 1
# fi

# echo "Extracting opendesk archive..."
# tar -xjf /tmp/opendesk.tar.bz2 -C "${OPENDESK_DIR}" --strip-components=1
# rm /tmp/opendesk.tar.bz2

# echo "Opendesk ${OPENDESK_VERSION} successfully extracted to ${OPENDESK_DIR}"

# loop over all files in /helmfile directory and copy them to helmfile/environments/prod/ directory
for file in /helmfile/*; do
    if [ -f "$file" ]; then
        cp "$file" "${OPENDESK_DIR}/helmfile/environments/$ENVIRONMENT/"
        echo "Copied $(basename "$file") to helmfile/environments/$ENVIRONMENT/"
    fi
done

# Execute the provided command or default CMD
exec "$@"
