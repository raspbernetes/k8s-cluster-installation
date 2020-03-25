#!/bin/bash
set -euo pipefail

# change to directory where bootstrap lives
cd "${0%/*}"

# source the environment variables for hostname, IP addresses and node type
# shellcheck disable=SC1091
source ./scripts/env

FILE="$RPI_HOME/reboot"
if [ ! -f "$FILE" ]; then
    # configure hostname and set timezone
    ./scripts/boot.sh
    ./scripts/hostname.sh

    # install system dependencies in order
    ./scripts/utils.sh
    ./scripts/docker.sh
    ./scripts/kubernetes.sh
    ./scripts/iptables.sh

    touch "$FILE"

    echo "Reboot in progress..."
    reboot
fi

# configure kubernetes with node type and/or initialising cluster
./scripts/init.sh

# ensure bootstrap scripts don't run again on boot and clean
sed -i "/bootstrap.sh/d" /etc/rc.local

echo "Finished booting! Kubernetes successfully running!"
