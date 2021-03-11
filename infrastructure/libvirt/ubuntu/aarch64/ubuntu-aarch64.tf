terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = "default"
}

# Vars
# ---

variable "hosts" {
  default = 4
}

variable "hostname_format" {
  type    = string
  default = "node-%02d"
}

variable "dns_domain" {
  description = "DNS domain name"
  default     = "ubuntu.local"

}

variable "network_cidr" {
  description = "Network CIDR"
  default     = "192.168.150.0/24"
}


# ---


resource "libvirt_network" "ubuntu_network" {
  name   = "ubuntu-network"
  mode   = "nat"
  domain = var.dns_domain

  dns {
    enabled = true
  }

  addresses = [var.network_cidr]
}

resource "libvirt_volume" "ubuntu" {
  name   = "ubuntu-${format(var.hostname_format, count.index + 1)}.qcow2"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/releases/groovy/release/ubuntu-20.10-server-cloudimg-arm64.img"
  format = "qcow2"
  count  = var.hosts
}

#Create Ubuntu Nodes
# Note you must set export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu" see https://github.com/dmacvicar/terraform-provider-libvirt/issues/738
resource "libvirt_domain" "node" {
  count   = var.hosts
  name    = format(var.hostname_format, count.index + 1)
  vcpu    = 8
  arch    = "aarch64"
  machine = "virt"
  firmware = "/usr/share/edk2/aarch64/QEMU_EFI-pflash.raw"
  memory  = 4096

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  xml {
    xslt = file("aarch64_machine.xsl")
  }

  disk {
    volume_id = element(libvirt_volume.ubuntu.*.id, count.index)
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  video {
    type = "ramfb"
  }

  network_interface {
    network_name   = "ubuntu-network"
    hostname       = format(var.hostname_format, count.index + 1)
    mac            = "52:54:00:00:00:a${count.index + 1}"
    wait_for_lease = false
  }

}
# -[Output]-------------------------------------------------------------
output "ipv4" {
  value = libvirt_domain.node.*.network_interface.0.addresses
}
