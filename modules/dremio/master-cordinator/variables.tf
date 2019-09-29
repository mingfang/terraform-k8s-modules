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

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable "config_map" {}

variable "zookeeper" {}
