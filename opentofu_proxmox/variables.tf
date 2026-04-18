variable "proxmox_endpoint" {
  description = "URL of the Proxmox API (e.g. https://192.168.1.10:8006/)"
  type        = string
}

variable "proxmox_username" {
  description = "Proxmox API user (e.g. root@pam)"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox API password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Name of the Proxmox node to deploy on (visible in the Proxmox UI)"
  type        = string
}

variable "template_vm_id" {
  description = "VM ID to assign to the Ubuntu cloud-init template"
  type        = number
  default     = 9000
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "my-vm"
}

variable "vm_id" {
  description = "VM ID for the deployed VM (must be unique on the node)"
  type        = number
  default     = 100
}

variable "vm_ssh_user" {
  description = "Username to create via cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "vm_ssh_public_key" {
  description = "SSH public key to inject via cloud-init (e.g. contents of ~/.ssh/id_ed25519.pub)"
  type        = string
  sensitive   = true
}

variable "vm_user_password" {
  description = "Password for the local user created via cloud-init"
  type        = string
  sensitive   = true
}
