# Raspbernetes

A guide to setup Kubernetes running on a Raspberry Pi cluster

## Contents

* [Prerequisites](#Prerequisites)
* [Getting Started](#Getting-Started)
  * [Master Node(s)](#Master-Node(s))
  * [Worker Node(s)](#Worker-Node(s))
* [Contributing](#Contributing)
* [Authors](#Authors)
* [License](#License)
* [Acknowledgments](#Acknowledgments)

## Prerequisites

Prior to getting started you must have completed the following setup instructions:

The SD card must be flashed with Raspbian Lite. If this has not been completed the official guide can be found [HERE](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).

Note: To setup SSH to your Raspberry Pi, you simply need a empty `ssh` file in the boot directory.

You must also have the following dependencies installed on your machine:

* make
* sshpass

An internet connection is also required for configuring the Raspberry Pi's.

## Getting Started

When configuring a Raspberry Pi there are two options for configuring it as a node in your Kubernetes cluster, it can either be a `master` or `worker`.

At this point the Raspberry Pi should be running and on the same network as your machine so it can be accessed over ssh.

### Master Node(s)

The master node configuration is copied from your machine to the Raspberry Pi with the following command:

```bash
RPI_HOSTNAME=k8s-master-01 KUBE_NODE_TYPE=master RPI_IP=192.168.1.101 make deploy
```

Once the deployment has completed you should be now able to manually `ssh` to the newly configured master node using the folling command:

```bash
ssh pi@k8s-master-01.local
```

Kubernetes should be running and you can view the syslogs with the following command:

```bash
tail -f /var/log/syslog
```

Additionally you can verify your nodes status is `READY` with the following command:

```bash
kubectl get nodes
```

Now that the master node is running successfully you can either add more master nodes to the cluster or create worker nodes within the cluster. To be able to connect additional nodes into the cluster we will need to extract the kube config and the join token output by the master node. This can be done with the following command:

```bash
make post-install
```

The kube config and join token should now be in the ./output directory and will be used in configuring additional nodes.

Note: Running the above commands will use a set of default variables, these are configured for setting up a master node and must be overriden for subsequent master or worker nodes. Also if the nodes status is `NOTREADY` then you should go back to checking the syslogs and check for any errors that may have occurs whilst setting up the node.

### Worker Node(s)

Work In Progress...

```bash
RPI_HOSTNAME=k8s-worker-01 KUBE_NODE_TYPE=worker RPI_IP=192.168.1.111 make deploy
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTION.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Michael Fornaro** - *Initial work* - [LinkedIn](https://www.linkedin.com/in/michael-fornaro-5b756179/)

See also the list of [contributors](https://github.com/xUnholy/raspbernetes/contributors) who participated in this project.

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

Wish to acknowledge the following people:

**Lucas Teligioridis** - [Github](https://github.com/lucasteligioridis) - Initial creator of the Raspbernetes setup with a fantastic setup guide for Linux based systems which can be found [HERE](https://itnext.io/headless-kubernetes-on-15-raspberry-pis-boot-in-under-8-minutes-808402ea2348?)
