variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "tcp"
      port = 9092
    },
  ]
}

variable image {
  default = "confluentinc/cp-kafka:5.5.1"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable "kafka_zookeeper_connect" {
  description = "Zookeeper URL, e.g. zookeeper:2181"
}
