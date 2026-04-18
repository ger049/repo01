output "template_vm_id" {
  description = "ID of the Ubuntu cloud-init template"
  value       = proxmox_virtual_environment_vm.ubuntu_template.vm_id
}

output "vm_id" {
  description = "ID of the deployed VM"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

output "vm_name" {
  description = "Name of the deployed VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ipv4_address" {
  description = "IPv4 address assigned to the VM (requires qemu-guest-agent)"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses
}
