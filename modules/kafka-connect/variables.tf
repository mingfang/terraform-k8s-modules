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
      name = "tcp1"
      port = 8083
    },
    {
      name = "tcp2"
      port = 5005
    },
  ]
}

variable image {
  default = "debezium/connect"
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

variable bootstrap_servers {}
