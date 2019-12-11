#!/bin/bash
set -euo pipefail

# change to directory where bootstrap lives
cd "${0%/*}"

# source the environment variables for hostname, IP addresses and node type
# shellcheck disable=SC1091
source ./config/env

FILE="$RPI_HOME/reboot"
if [ ! -f "$FILE" ]; then
    # configure hostname and set timezone
    ./config/boot.sh
    ./config/hostname.sh

    # install system dependencies in order
    ./install/utils.sh
    ./install/docker.sh
    ./install/kubernetes.sh
    ./install/iptables.sh

    touch "$FILE"

    echo "Reboot in progress..."
    reboot
fi

# configure kubernetes with node type and/or initialising cluster
./config/init.sh

# ensure bootstrap scripts don't run again on boot and clean
sed -i "/bootstrap.sh/d" /etc/rc.local

echo "Finished booting! Kubernetes successfully running!"
