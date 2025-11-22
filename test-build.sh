#!/bin/bash
# Example usage script for opendesk-bootstrap Docker image

set -e

IMAGE_NAME="opendesk-bootstrap"

echo "Building the Docker image..."
docker build -t "${IMAGE_NAME}" .

echo ""
echo "Image built successfully!"
echo ""

echo "Testing default version (v1.9.0)..."
docker run --rm "${IMAGE_NAME}" bash -c "echo 'Container started with version:' && echo \$OPENDESK_VERSION"

echo ""
echo "Testing with custom version (v1.8.0)..."
docker run --rm -e OPENDESK_VERSION=v1.8.0 "${IMAGE_NAME}" bash -c "echo 'Container started with version:' && echo \$OPENDESK_VERSION"

echo ""
echo "Checking installed tools..."
echo "kubectl version:"
docker run --rm "${IMAGE_NAME}" kubectl version --client --short 2>/dev/null || docker run --rm "${IMAGE_NAME}" kubectl version --client

echo ""
echo "helm version:"
docker run --rm "${IMAGE_NAME}" helm version --short

echo ""
echo "helmfile version:"
docker run --rm "${IMAGE_NAME}" helmfile version

echo ""
echo "git version:"
docker run --rm "${IMAGE_NAME}" git --version

echo ""
echo "Checking helm plugins..."
docker run --rm "${IMAGE_NAME}" helm plugin list

echo ""
echo "All tests completed successfully!"
