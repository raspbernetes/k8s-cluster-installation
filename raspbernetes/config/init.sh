#!/bin/bash
set -euo pipefail

init_master() {
    echo "Initializing Kubernetes Master Node"
    kubeadm init --token-ttl=0 | tee  >(tail -n 2 > "$RPI_HOME/connect.sh")
    chmod +x "$RPI_HOME/connect.sh"
    kube_config
    init_cni
}

kube_config() {
    echo "Setup kube config"
    mkdir -p "/root/.kube"
    mkdir -p "$RPI_HOME/.kube"
    cp -f /etc/kubernetes/admin.conf "/root/.kube/config"
    cp -i /etc/kubernetes/admin.conf "$RPI_HOME/.kube/config"
    chown "$(id -u):$(id -g)" "/root/.kube/config"
    chown "$(id -u pi):$(id -g pi)" "$RPI_HOME/.kube/config"
}

init_cni() {
    echo "Initializing CNI: Weave"
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}

# determine the node type and run specific function
if [ "${KUBE_NODE_TYPE}" == "master" ]; then
    echo "Detected as master node type, need to either join existing cluster or initialise new one"
    init_master
elif [ "${KUBE_NODE_TYPE}" == "worker" ]; then
    echo "Detected as worker node type, need to join existing cluster!"
    ./connect.sh
fi
