variable "name" {}

variable "namespace" {}

variable image {
  default = "registry:2"
}

variable ports {
  default = [
    {
      name = "http"
      port = 5000
    },
  ]
}

variable "env" {
  default = [
    {
      name  = "REGISTRY_STORAGE_DELETE_ENABLED"
      value = "true"
    },
  ]
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {
  }
}

variable "resources" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "pvc_name" {
  default = null
}
