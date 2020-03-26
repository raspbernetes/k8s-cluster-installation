# Raspbernetes

This is an open source project designed to bootstrap a running Kubernetes cluster on Raspberry Pi's.

## Introduction

This guide will walk through the steps required to bootstrap a running Kubernetes cluster with a highly available topology. You will learn and configure the CRI and CNI of your choice (assuming it is supported) and understand how to setup load balancing between your multi master cluster.

> Note: If you wish to use Raspbian Lite please use the following [guide](raspbian/README.md).

## Prerequisites

Prior to getting started you will need to have several things done first. Assuming you already have the [hardware](#Hardware) available, you will need to do the following:

1. Flash OS onto SD card. Guide [Here](setup/README.md)
2. Install Ansible. Download [Here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
3. SSH connectivity to each node. (Step 1 requires you setup SSH keys)

## Getting Started

Once the Raspberry Pi's are running and all the prerequisites have been completed we're now ready to setup the Ansible inventory.

Open the [inventory file](ansible/inventory) - each machine that will be joining the Kubernetes cluster must be defined as either a master or worker node. To leverage the highly available topology configuration you would ideally have 3 masters available as a minimum, otherwise 1 master node is fine, however, it won't be highly available.

> Note: Ensure the `hostname` matches what the machine was given when flashed the SD card and `ansible_host` matches the IP allocated to the host on your prefered subnet.

When the inventory has been configured with all the hosts that will be joining the Kubernetes cluster we can run the following command to verify SSH connectivity can be established.

```bash
ansible all -m ping -i inventory -u pi
```

A successful response should look something like the following:

```diff
+ k8s-worker-01 | SUCCESS => {
+    ...
+    "changed": false,
+    "ping": "pong"
+    ...
+}
```

> Note: If your output returns success for each ping then you can continue, otherwise there may be some misconfiguration of either the inventory file, or network connectivity issues.

There are a variety of different configurable options in the Ansible automation. These options can be located in the [vars.yml](ansible/vars.yml) file. In this file you have the option to change the container runtime ("CRI") and the container network interface ("CNI") that is used within the cluster.

Below is a matrix of the currently supported options.

**Container Runtime**

| Name | Supported |
| ---- | --------- |
| Docker | Yes |
| ContainerD | Yes |

**Container Network Interface**

| Name | Supported |
| ---- | --------- |
| Weave | Yes |
| Flannel | Yes |

Assuming all previous steps and configuration are correct the last thing to do is to execute the playbook. The playbook that should be used is the `k8s-all.yml` playbook, this will handle all the master and worker node logic and sequencing.

```bash
env ANSIBLE_CONFIG=ansible.cfg ansible-playbook \
    -i ansible/inventory \
    ansible/playbooks/k8s-all.yml
```

IF there was no errors you should be able to execute the following command to check the status of the nodes in the cluster:

```bash
k get nodes --kubeconfig ansible/playbooks/output/k8s-config.yam
```

Output:

```bash
NAME            STATUS     ROLES    AGE     VERSION
k8s-master-01   Ready      master   4m45s   v1.17.4
k8s-master-02   Ready      master   70s     v1.17.4
k8s-master-03   Ready      master   79s     v1.17.4
k8s-worker-01   Ready      <none>   16s     v1.17.4
```

**Congratulations!** you have successfully started your own Kubernetes cluster!

> If you weren't lucky enough to have everything successful on the first attempt please open an [issue](https://github.com/raspbernetes/k8s-cluster-installation/issues/new) with as much context and we'll try to solve and improve for future people.

## Architecture

The following diagram demonstrates the overall cluster design which will be implemented via the Ansible automation if you follow the above guide. 

> To obtain a highly available Kubernetes cluster we've chosen to use the [stacked etcd toplogy](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/#stacked-etcd-topology). This is the default configuration as the [external etcd cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/#external-etcd-topology) alternative requires additional compute resources.

<img src="./docs/images/raspbernetes-cluster-design.png"/>

