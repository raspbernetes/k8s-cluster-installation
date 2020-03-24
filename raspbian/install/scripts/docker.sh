#!/bin/bash
set -euo pipefail

curl -sSL get.docker.com | sh && \
    usermod pi -aG docker

dphys-swapfile swapoff && \
    dphys-swapfile uninstall && \
    update-rc.d dphys-swapfile remove && \
    systemctl disable dphys-swapfile.service

# setup daemon to user systemd as per kubernetes best practices
cat << EOF >> /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF