variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  type = list(any)
  default = [
    {
      name = "http"
      port = 8000
    },
  ]
}

variable "image" {
  default = "landoop/kafka-connect-ui"
}

variable "env" {
  type    = list(any)
  default = []
}

variable "annotations" {
  type    = map(any)
  default = {}
}

variable "node_selector" {
  type    = map(any)
  default = {}
}

variable "overrides" {
  default = {}
}

variable "kafka_connect" {}
