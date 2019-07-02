### Compute ###
resource "null_resource" "remote-exec_init" {
  count = "${var.ords_compute}"
  depends_on = ["oci_core_instance.ORDS-Comp-Instance"]

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "10m"
      host        = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    source      = "./userdata/files_init.zip"
    destination = "~/files_init.zip"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "unzip -j files_init.zip \"*config_init.sh\"",
      "chmod +x ~/config_init.sh",
      "sudo ~/config_init.sh",
    ]
  }
}

resource "null_resource" "remote-exec_init1" {
  count = "${1 - var.ords_compute}"

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "10m"
      host        = "${var.target_db_ip_public}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    source      = "./userdata/files_init.zip"
    destination = "~/files_init.zip"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${var.target_db_ip_public}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "unzip -j files_init.zip \"*config_init_1.sh\"",
      "chmod +x ~/config_init_1.sh",
      "sudo ~/config_init_1.sh",
    ]
  }
}

locals {
  web_server = "${1 - var.web_srv}"
  ords_server = "${1 - var.ords_compute}"
}

resource "null_resource" "remote-exec_jetty-1" {
  depends_on = ["null_resource.remote-exec_init"]

  count = "${local.web_server == "1" && var.ords_compute == "1" ? 1 : 0}" # if web_srv=0 then jetty is configured

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "10m"
      host        = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    source      = "./userdata/files_jetty.zip"
    destination = "~/files_jetty.zip"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "unzip -j files_jetty.zip \"*config_jetty_init.sh\"",
      "chmod +x ~/config_jetty_init.sh",
      "sudo ~/config_jetty_init.sh ${var.com_port}",
    ]
  }
}

resource "null_resource" "remote-exec_jetty-11" {
  depends_on = ["null_resource.remote-exec_init1"]

  count = "${local.web_server == "1" && var.ords_compute == "0" ? 1 : 0}" # if web_srv=0 then jetty is configured

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "10m"
      host        = "${var.target_db_ip_public}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    source      = "./userdata/files_jetty.zip"
    destination = "~/files_jetty.zip"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${var.target_db_ip_public}"
      user        = "${var.HostUserName}"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "unzip -j files_jetty.zip \"*config_jetty_init_1.sh\"",
      "chmod +x ~/config_jetty_init_1.sh",
      "sudo ~/config_jetty_init_1.sh ${var.com_port}",
    ]
  }
}

resource "null_resource" "remote-exec_jetty-2" {
  depends_on = ["null_resource.remote-exec_jetty-1"]

  count = "${local.web_server == "1" && var.ords_compute == "1" ? 1 : 0}" # if web_srv=0 then jetty is configured

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
      user        = "oracle"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "unzip -j files_jetty.zip",
      "chmod +x ~/*.sh",
      "./config_jetty_ords.sh ${var.target_db_admin_pw} ${var.target_db_ip} ${var.target_db_srv_name} ${data.oci_core_vnic.InstanceVnic.public_ip_address} ${var.com_port} ${var.URL_ORDS_file}",
    ]
  }
}

resource "null_resource" "remote-exec_jetty-22" {
  depends_on = ["null_resource.remote-exec_jetty-11"]

  count = "${local.web_server == "1" && var.ords_compute == "0" ? 1 : 0}" # if web_srv=0 then jetty is configured

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${var.target_db_ip_public}"
      user        = "oracle"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "unzip -j files_jetty.zip",
      "chmod +x ~/*.sh",
      "./config_jetty_ords.sh ${var.target_db_admin_pw} ${var.target_db_ip} ${var.target_db_srv_name} ${var.target_db_ip_public} ${var.com_port} ${var.URL_ORDS_file}",
    ]
  }
}

resource "null_resource" "remote-exec_jetty-apex" {
  depends_on = ["null_resource.remote-exec_jetty-2"]

  # if web_srv=0(jetty) 
  count = "${local.web_server == "1" && var.ords_compute == "1" ? 1 : 0}"

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
      user        = "oracle"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "./config_jetty_apex.sh ${var.target_db_admin_pw} ${var.target_db_ip} ${var.target_db_srv_name} ${data.oci_core_vnic.InstanceVnic.public_ip_address} ${var.com_port} ${var.URL_APEX_file} ${var.APEX_install_mode}",
    ]
  }
}

resource "null_resource" "remote-exec_jetty-apex1" {
  depends_on = ["null_resource.remote-exec_jetty-22"]

  # if web_srv=0(jetty) 
  count = "${local.web_server == "1" && var.ords_compute == "0" ? 1 : 0}"

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${var.target_db_ip_public}"
      user        = "oracle"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "./config_jetty_apex.sh ${var.target_db_admin_pw} ${var.target_db_ip} ${var.target_db_srv_name} ${var.target_db_ip_public} ${var.com_port} ${var.URL_APEX_file} ${var.APEX_install_mode}",
    ]
  }
}

/*resource "null_resource" "remote-exec_jetty-Secure-FQDN-Access" {
  depends_on = ["null_resource.remote-exec_jetty-2"]

  # if web_srv=0(jetty) AND Secure_FQDN_access=0(enabling FQDN access), this resource is configured
  count = "${(1 - var.web_srv) - var.Secure_FQDN_access * (1 - var.web_srv)}" 

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
      user        = "oracle"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "./config_cert.sh ${var.tenancy_ocid} ${var.compartment_ocid} ${var.user_ocid} ${var.fingerprint} \"${var.api_private_key}\" ${var.InstanceName}.${oci_dns_zone.ORDS-Zone.name}",
      "./config_jetty_ca-ssl.sh ${var.InstanceName}.${oci_dns_zone.ORDS-Zone.name}",
    ]
  }
}*/
