output "vm_public_ip_of_master" {
  value = oci_core_instance.master.public_ip
}

output "vm_public_ip_of_worker1" {
  value = oci_core_instance.worker[0].public_ip
}

output "vm_public_ip_of_worker2" {
  value = oci_core_instance.worker[1].public_ip
}