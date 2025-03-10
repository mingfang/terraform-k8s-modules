variable "name" {}

variable "namespace" {}

variable image {
  default = "confluentinc/cp-kafka-connect:6.2.4"
}

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

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
  description = "keys are mounted to /etc/kafka"
}

variable "pvc" {
  default = null
  description = "install plugins into this volume"
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
  default = "/usr/share/confluent-hub-components"
}

variable "plugins" {
  default = []
  description = "install list of confluent-hub plugins"
}