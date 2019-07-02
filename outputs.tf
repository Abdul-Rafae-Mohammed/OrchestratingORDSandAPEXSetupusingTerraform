# Output the private and public IPs of the instance
output "InstancePrivateIP" {
  value = ["${var.ords_compute == "1" ? data.oci_core_vnic.InstanceVnic.private_ip_address : var.target_db_ip}"]
}

output "InstancePublicIP" {
  value = ["${var.ords_compute == "1" ? data.oci_core_vnic.InstanceVnic.public_ip_address : var.target_db_ip_public}"]
}

