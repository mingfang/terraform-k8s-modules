variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable ports {
  type = list
  default = [
    {
      name = "http"
      port = 8000
    },
  ]
}

variable image {
  default = "landoop/kafka-topics-ui"
}

variable "env" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
  default = {}
}

variable "node_selector" {
  type    = map
  default = {}
}

variable "overrides" {
  default = {}
}

variable kafka_rest_proxy {}
