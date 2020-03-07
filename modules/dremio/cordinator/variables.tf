variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "dremio/dremio-oss:4.1.4"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
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