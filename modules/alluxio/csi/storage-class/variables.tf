variable "name" {}

variable "master_hostname" {}

variable "master_port" {}

variable "alluxio_path" {
  default = null
}

variable "java_options" {
  default = null
}

variable "mount_options" {
  default = null
}

variable "domain_socket" {
  default = null
}

variable "_provisioner" {}