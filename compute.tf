resource "oci_core_instance" "ORDS-Comp-Instance" {

  count = "${var.ords_compute}"

  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.ComputeDisplayName}"
  hostname_label      = "${var.InstanceName}"
  shape               = "${var.InstanceShape}"
  subnet_id           = "${var.subnet_ocid}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.BootStrapFile))}"
  }

  source_details {
    source_id   = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
    source_type = "image"
  }

  timeouts {
    create = "60m"
  }
}
