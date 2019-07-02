/*resource "oci_dns_record" "ORDS-Record-a" {

  count = "${1 - var.Secure_FQDN_access}" # if Secure_FQDN_access=0 then Record resource is configured

  zone_name_or_id = "${oci_dns_zone.ORDS-Zone.name}"
  domain          = "${var.InstanceName}.${oci_dns_zone.ORDS-Zone.name}"
  rtype           = "A"
  rdata           = "${var.target_db_ip_public}"
  ttl             = 60
}*/

