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
