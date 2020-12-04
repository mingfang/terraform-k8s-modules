variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 4040
    },
  ]
}

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
      cpu    = "25m"
      memory = "80Mi"
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