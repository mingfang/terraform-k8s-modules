variable "name" {}

variable "namespace" {
  default = null
}

variable "debezium-version" {
  default = "0.9"
}

variable "zookeeper_storage_class" {}

variable "zookeeper_storage" {}

variable "zookeeper_count" {}

variable "kafka_storage_class" {}

variable "kafka_storage" {}

variable "kafka_count" {}
