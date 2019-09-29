/*
common variables
*/

variable "name" {}

variable "namespace" {
  default = ""
}

variable "replicas" {
  default = 1
}

//this image contains example data
variable image {
  default = "debezium/example-mysql"
}

variable port {
  default = 3306
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
service specific variables
*/

variable mysql_user {
  default = "mysqluser"
}

variable mysql_password {
  default = "mysqlpw"
}

variable mysql_database {
  default = ""
}

variable "mysql_root_password" {
  default = "debezium"
}

/*
locals
*/

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

/*
output
*/

output "name" {
  value = "${k8s_core_v1_service.this.metadata[0].name}"
}

output "port" {
  value = "${k8s_core_v1_service.this.spec[0].ports[0].port}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.this.spec[0].cluster_ip}"
}

output "statefulset_uid" {
  value = "${k8s_apps_v1_stateful_set.this.metadata[0].uid}"
}
