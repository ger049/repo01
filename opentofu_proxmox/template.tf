# Download the Ubuntu 24.04 LTS cloud image to Proxmox local storage
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  node_name    = var.proxmox_node
  content_type = "iso"
  datastore_id = "local"

  file_name = "ubuntu-24.04-cloud-amd64.img"
  url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

  # Optional: pin a checksum to verify the download.
  # Get the current value from:
  #   https://cloud-images.ubuntu.com/noble/current/SHA256SUMS
  # checksum_algorithm = "sha256"
  # checksum           = "abc123..."

  overwrite = false # skip re-download if the file already exists
}

# Build a reusable VM template from the downloaded cloud image
resource "proxmox_virtual_environment_vm" "ubuntu_template" {
  name      = "ubuntu-2404-template"
  vm_id     = var.template_vm_id
  node_name = var.proxmox_node

  template  = true  # marks VM as template; prevents accidental start
  started   = false

  cpu {
    cores = 1
    type  = "host"
  }

  memory {
    dedicated = 1024
  }

  # Root disk — imported from the cloud image
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    size         = 20
    discard      = "on"
    iothread     = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Cloud-init configuration embedded into the template
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

  serial_device {} # cloud-init needs a serial console for early boot output

  operating_system {
    type = "l26" # Linux 2.6+ kernel
  }

  agent {
    enabled = true # qemu-guest-agent is pre-installed in Ubuntu cloud images
  }
}
