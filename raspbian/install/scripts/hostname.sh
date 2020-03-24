#!/bin/bash
set -euo pipefail

echo "Setting hostname to: ${RPI_HOSTNAME}"
hostnamectl --transient set-hostname "${RPI_HOSTNAME}"
hostnamectl --static set-hostname "${RPI_HOSTNAME}"
hostnamectl --pretty set-hostname "${RPI_HOSTNAME}"
sed -i s/raspberrypi/"${RPI_HOSTNAME}"/g /etc/hosts

# For more configuration options read the following link:
# https://wiki.archlinux.org/index.php/dhcpcd#Configuration
cat << EOF >> /etc/dhcpcd.conf
interface $RPI_NETWORK_TYPE
static ip_address=$RPI_IP/24
static routers=$RPI_DNS
static domain_name_servers=$RPI_DNS
EOF

echo "Setting timezone to: ${RPI_TIMEZONE}"
hostnamectl set-location "${RPI_TIMEZONE}"
timedatectl set-timezone "${RPI_TIMEZONE}"

FILE=/etc/motd
if [ -f "$FILE" ]; then
    rm -f "$FILE"
fi
