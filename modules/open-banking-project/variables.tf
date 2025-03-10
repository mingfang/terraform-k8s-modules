variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/obp-base"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "OBP_KAFKA_BOOTSTRAP_HOSTS" {
  default = null
}

variable "OBP_KAFKA_CLIENT_ID" {
  default = null
}

variable "OBP_KAFKA_PARTITIONS" {
  default = 1
}

variable "OBP_KAFKA_REQUEST_TOPIC" {
  default = "Request"
}

variable "OBP_KAFKA_RESPONSE_TOPIC" {
  default = "Response"
}

variable "OBP_CONNECTOR" {
  default = null
}

variable "OBP_DB_DRIVER" {
  default = null
}

variable "OBP_DB_URL" {
  default = null
}

variable "OBP_LOGGER_LOGLEVEL" {
  default = "INFO"
}

variable "OBP_AKKA_CONNECTOR_LOGLEVEL" {
  default = "INFO"
}

variable "logback_xml_file" {
  default = ""
}

