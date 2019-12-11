#!/bin/bash
set -euo pipefail

apt-get update && apt-get install -y ebtables arptables
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy

# Set /proc/sys/net/bridge/bridge-nf-call-iptables to 1 by running 
# sysctl net.bridge.bridge-nf-call-iptables=1 to pass bridged IPv4 traffic to iptables’ chains. 
# This is a requirement for some CNI plugins to work.
sysctl net.bridge.bridge-nf-call-iptables=1

# Additional configuration
sysctl net.bridge.bridge-nf-call-ip6tables=1
sysctl net.bridge.bridge-nf-call-arptables=1