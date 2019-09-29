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
      port = 5000
    },
  ]
}

variable image {
  default = "registry:2"
}

variable "env" {
  type = list
  default = [
    {
      name  = "REGISTRY_STORAGE_DELETE_ENABLED"
      value = "true"
    },
  ]
}

variable "annotations" {
  type    = map
  default = null
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