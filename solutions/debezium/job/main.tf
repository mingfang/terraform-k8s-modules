/**
 * Use this module to run a job to configure the source and sink connectors
 */

variable "name" {}

variable "namespace" {
  default = null
}

variable "kafka_connect" {}

variable "connector_name" {}

variable "connector_config" {}

module "job" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/job"
  name      = "${var.name}"
  namespace = var.namespace

  command = <<-EOF
    until curl -s -H 'Accept:application/json' ${var.kafka_connect}
    do echo 'Waiting for Kafka Connect...'; sleep 10; done
    curl -s -X DELETE ${var.kafka_connect}/connectors/${var.connector_name}
    curl -s -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' \
      ${var.kafka_connect}/connectors/ -d '${var.connector_config}'
    EOF
}
