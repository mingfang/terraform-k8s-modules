variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8088
    },
  ]
}

variable image {
  default = "confluentinc/ksqldb-server:0.12.0"
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

variable KSQL_BOOTSTRAP_SERVERS {}

variable KSQL_KSQL_SCHEMA_REGISTRY_URL {
  default = null
}

variable "KSQL_KSQL_CONNECT_URL" {
  default = null
  description = ""
}
variable "KSQL_CONNECT_KEY_CONVERTER" {
  default = "io.confluent.connect.avro.AvroConverter"
}
variable "KSQL_CONNECT_VALUE_CONVERTER" {
  default = "io.confluent.connect.avro.AvroConverter"
}
variable "KSQL_CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR" {
  default = 1
}
variable "KSQL_CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR" {
  default = 1
}
variable "KSQL_CONNECT_STATUS_STORAGE_REPLICATION_FACTOR" {
  default = 1
}

