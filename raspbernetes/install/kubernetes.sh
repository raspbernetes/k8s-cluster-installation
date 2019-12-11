#!/bin/bash
set -euo pipefail

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
# https://askubuntu.com/questions/1100800/kubernetes-installation-failing-ubuntu-16-04
# cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
# deb http://packages.cloud.google.com/apt/ kubernetes-xenial main
# EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl kubectx
apt-mark hold kubelet kubeadm kubectl

echo "Adding \"cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory\" to /boot/cmdline.txt"

cp /boot/cmdline.txt /boot/cmdline_backup.txt
ORIG="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo "$ORIG" | tee /boot/cmdline.txt

if [ "${KUBE_NODE_TYPE}" == "master" ]; then
    echo "Pulling down all kubeadm images..."
    kubeadm config images pull
fi
