provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true # set to false if you have a valid TLS certificate
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  vm_id     = var.vm_id
  node_name = var.proxmox_node

  # Clone from the Ubuntu cloud-init template defined in template.tf
  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu_template.vm_id
    full  = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048 # 2 GB in MiB
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20 # GB
    discard      = "on"
    iothread     = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Override cloud-init settings per-VM (overrides template defaults)
  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_ssh_user
      password = var.vm_user_password
      keys     = [var.vm_ssh_public_key]
    }
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  started = true
}
