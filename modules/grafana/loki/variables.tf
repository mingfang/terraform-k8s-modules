variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 3100
    },
  ]
}

variable "image" {
  default = "grafana/loki:1.6.1"
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

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}

variable "config_file" {
  default = ""
}

variable "auth_enabled" {
  default = "true"
}

variable "cassandra" {}
