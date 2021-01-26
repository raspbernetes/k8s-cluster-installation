terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.2"
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

# ---


resource "libvirt_volume" "os_image_ubuntu" {
  name   = "os_image_ubuntu"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
}

resource "libvirt_volume" "ubuntu" {
  name           = "ubuntu-${format(var.hostname_format, count.index + 1)}.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  format         = "qcow2"
  size           = 5361393152
  count          = var.hosts
}

#Create Ubuntu Nodes
resource "libvirt_domain" "node" {
  count  = var.hosts
  name   = format(var.hostname_format, count.index + 1)
  vcpu   = 2
  memory = 2048

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = element(libvirt_volume.ubuntu.*.id, count.index)
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
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


  network_interface {
    network_name   = "default"
    hostname       = format(var.hostname_format, count.index + 1)
    mac            = "52:54:00:00:00:a${count.index + 1}"
    wait_for_lease = true
  }

}

# -[Output]-------------------------------------------------------------
output "ipv4" {
  value = libvirt_domain.node.*.network_interface.0.addresses
}
