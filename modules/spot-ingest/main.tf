/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

/*
common variables
*/

variable "name" {
  default = "spot-ingest"
}

variable "namespace" {
  default = ""
}

variable "replicas" {
  default = 1
}

variable image {
  default = "registry.rebelsoft.com/spot:latest"
}

//list of name,port pairs
variable ports {
  type = "list"

  default = [
    {
      name = "http"
      port = 8000
    },
  ]
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "node_selector" {
  type    = "map"
  default = {}
}

variable "dns_policy" {
  default = ""
}

variable "priority_class_name" {
  default = ""
}

variable "restart_policy" {
  default = ""
}

variable "scheduler_name" {
  default = ""
}

variable "termination_grace_period_seconds" {
  default = 30
}

variable "session_affinity" {
  default = ""
}

variable "service_type" {
  default = ""
}

/*
service specific variables
*/

variable "namenode" {}

variable "kafka_server" {}

variable "kafka_port" {}

variable "zookeeper_server" {}

variable "zookeeper_port" {}

/*
locals
*/

locals {
  labels {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

/*
output
*/

output "name" {
  value = "${k8s_core_v1_service.this.metadata.name}"
}

output "ports" {
  value = "${k8s_core_v1_service.this.spec.ports}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.this.spec.cluster_ip}"
}

output "deployment_uid" {
  value = "${k8s_apps_v1_deployment.this.metadata.uid}"
}
