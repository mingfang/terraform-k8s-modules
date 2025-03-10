variable "name" {}

variable "namespace" {}

variable "image" {
  default = "docker.io/weaveworks/scope:1.13.1"
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
      cpu    = "100m"
      memory = "100Mi"
    }
    limits = {
      memory = "2Gi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "weave_scope_app_url" {}
