### Common ###
variable "tenancy_ocid" {}

variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "subnet_ocid" {}
variable "target_db_admin_pw" {}
variable "target_db_ip" {}
variable "target_db_ip_public" {}
variable "target_db_srv_name" {}
variable "target_db_name" {}
variable "api_private_key" {}
variable "ords_compute" {}

variable "HostUserName" {
  default = "opc"
}

variable "BootStrapFile" {
  default = "./userdata/bootstrap.sh"
}

# Choose an Availability Domain
variable "AD" {
  default = "1"
}

# Web Server Flag:
#    0 => Jetty in ORDS 
#    1 => Apach Tomcat
variable "web_srv" {
  default = "0"
}

# FQDN Access Flag:
#    0 => FQDN access w/ CA cert SSL enabled (ZoneName required)
#    1 => IP address access
variable "Secure_FQDN_access" {
  default = "1"
}

### Compute ####
variable "ComputeDisplayName" {
  default = "ORDS-Compute"
}

variable "InstanceName" {
  default = "ords-comp" // hostname
}

variable "InstanceShape" {
  default = "VM.Standard2.1"
}

variable "InstanceOS" {
  default = "Oracle Linux"
}

variable "InstanceOSVersion" {
  default = "7.6"
}

variable "com_port" {
  default = "8443"
}

variable "URL_ORDS_file" {
  default = "https://objectstorage.<region>.oraclecloud.com/p/XXXXX/o/ords.war"
}

# Optional: required only for using Tomcat
variable "URL_tomcat_file" {
  default = "https://objectstorage.<region>.oraclecloud.com/p/XXXXX/o/apache-tomcat-8.5.NN.tar.gz"
}

# Optional: required only when configuring APEX
variable "URL_APEX_file" {
  default = "https://objectstorage.<region>.oraclecloud.com/p/XXXXX/o/apex_NN.zip"
}

# APEX Install Mode Flag:
# Optional: required only when configuring APEX
#    0 => Full Development mode
#    1 => Runtime mode
variable "APEX_install_mode" {
  default = "0"
}
