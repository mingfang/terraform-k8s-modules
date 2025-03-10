variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable image {
  default = "openwhisk/invoker:71b7d56"
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

variable "overrides" {
  default = {}
}

variable "whisk_config_name" {}
variable "db_config_name" {}
variable "db_secret_name" {}

variable "KAFKA_HOSTS" {
  description = "openwhisk-kafka-0.openwhisk-kafka.default.svc.cluster.local:9092"
}
variable "ZOOKEEPER_HOSTS" {
  description = "openwhisk-zookeeper-0.openwhisk-zookeeper.default.svc.cluster.local:2181"
}



