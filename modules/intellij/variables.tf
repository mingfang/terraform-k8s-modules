variable "name" {}

variable "namespace" {}

variable "image" {
  default = "registry.rebelsoft.com/projector-idea-c"
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8887
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "additional_containers" {
  default = []
}

variable "pvc" {
  default = null
}

variable "extra_pvcs" {
  default = []
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}
