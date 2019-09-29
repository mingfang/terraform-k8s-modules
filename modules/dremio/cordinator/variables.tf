variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "dremio/dremio-oss:latest"
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
  default = null
}

variable "replicas" {
  default = 1
}

variable "overrides" {
  default = {}
}

variable "config_map" {}

variable "zookeeper" {}

variable "master-cordinator" {}