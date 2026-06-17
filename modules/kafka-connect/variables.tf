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
      name = "tcp1"
      port = 8083
    },
    {
      name = "tcp2"
      port = 5005
    },
  ]
}

variable "image" {
  default = "debezium/connect"
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

variable "bootstrap_servers" {}
