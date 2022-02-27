variable "name" {}

variable "namespace" {}

variable "image" {
  default = "thatdot/quine"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "4Gi"
    }
    limits = {
      memory = "8Gi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "quine_config" {
  default     = null
  description = "configmap with quine.conf key"
}
