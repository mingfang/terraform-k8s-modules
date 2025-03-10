variable "name" {}

variable "namespace" {}

variable "image" {
  default = "prom/alertmanager:v0.18.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9093
    }
  ]
}

variable "resources" {
  default = {
    requests = {
      cpu    = "50m"
      memory = "25Mi"
    }
  }
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

variable "gateway_url" {}
