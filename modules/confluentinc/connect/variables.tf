variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8083
    },
    {
      name = "tcp2"
      port = 5005
    },
  ]
}

variable image {
  default = "confluentinc/cp-kafka-connect:5.5.1"
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

variable CONNECT_BOOTSTRAP_SERVERS {}

variable CONNECT_SCHEMA_REGISTRY_URL {
  default = null
}

variable "CONNECT_KEY_CONVERTER" {
  default = "io.confluent.connect.avro.AvroConverter"
}
variable "CONNECT_VALUE_CONVERTER" {
  default = "io.confluent.connect.avro.AvroConverter"
}
variable "CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR" {
  default = 1
}
variable "CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR" {
  default = 1
}
variable "CONNECT_STATUS_STORAGE_REPLICATION_FACTOR" {
  default = 1
}

variable "CONNECT_PLUGIN_PATH" {
  default = "/home/appuser/plugins"
}
