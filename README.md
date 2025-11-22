# opendesk-bootstrap

Bootstrap opendesk helmfile deployment using a minimal Alpine Linux Docker image.

## Overview

This Docker image provides a minimal Alpine Linux environment with the following tools pre-installed:
- **kubectl** - Kubernetes command-line tool
- **helm** (< 4.0) - Kubernetes package manager
- **helm diff plugin** - Show a diff explaining what a helm upgrade would change
- **helmfile** - Deploy Kubernetes Helm Charts
- **git** - Version control system

Upon container startup, the image automatically downloads and extracts the opendesk deployment files from GitLab.

## Building the Image

```bash
docker build -t opendesk-bootstrap .
```

## Usage

### Basic Usage (Default Version)

Run the container with the default opendesk version (v1.9.0):

```bash
docker run -it opendesk-bootstrap
```

### Custom Version

Specify a different opendesk version using the `OPENDESK_VERSION` environment variable:

```bash
docker run -it -e OPENDESK_VERSION=v1.10.0 opendesk-bootstrap
```

### Running Commands

Execute specific commands in the container:

```bash
# Check installed tools
docker run --rm -it opendesk-bootstrap kubectl version --client
docker run --rm -it opendesk-bootstrap helm version
docker run --rm -it opendesk-bootstrap helmfile version

# Access the extracted opendesk files
docker run --rm -it opendesk-bootstrap ls -la /workspace/opendesk
```

### Interactive Shell

Start an interactive bash shell:

```bash
docker run -it opendesk-bootstrap bash
```

Once inside the container, you can access the opendesk files at `/workspace/opendesk`.

## Environment Variables

- `OPENDESK_VERSION`: Version of opendesk to download (default: `v1.9.0`)

## Directory Structure

- `/workspace/opendesk`: Location where opendesk files are extracted
- `/workspace`: Default working directory

## Version Information

The Dockerfile uses the following tool versions by default (configurable via build args):
- kubectl: 1.28.4
- helm: 3.13.3
- helmfile: 0.159.0

## Customizing Tool Versions

You can customize tool versions during build:

```bash
docker build \
  --build-arg KUBECTL_VERSION=1.29.0 \
  --build-arg HELM_VERSION=3.14.0 \
  --build-arg HELMFILE_VERSION=0.160.0 \
  -t opendesk-bootstrap .
```

