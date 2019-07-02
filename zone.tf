/*resource "oci_dns_zone" "ORDS-Zone" {

  count = "${1 - var.Secure_FQDN_access}" # if Secure_FQDN_access=0 then Zone resource is configured

  compartment_id = "${var.compartment_ocid}"
  name           = "${var.ZoneName}"
  zone_type      = "PRIMARY"
}*/
