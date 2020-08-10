variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 9021
    },
  ]
}

variable image {
  default = "confluentinc/cp-enterprise-control-center:5.5.1"
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

variable CONTROL_CENTER_ZOOKEEPER_CONNECT {}
variable CONTROL_CENTER_BOOTSTRAP_SERVERS {}
variable CONTROL_CENTER_SCHEMA_REGISTRY_URL {}
variable CONTROL_CENTER_REPLICATION_FACTOR {
  default = 1
}
