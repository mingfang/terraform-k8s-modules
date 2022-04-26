variable "name" {}

variable "namespace" {}

variable "image" {
  default = "ghcr.io/deephaven/web:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 80
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "pvc" {
  default = null
}