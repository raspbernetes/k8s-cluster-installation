#!/bin/bash
set -euo pipefail

echo "Installing additional packages..."
apt-get update && apt-get install -y --no-install-recommends apt-transport-https \
    software-properties-common zip jq git vim curl
