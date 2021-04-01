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
  default = "grafana/loki:2.2.0"
}

variable "args" {
  default = []
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
  default = null
}

variable "rules" {
  default     = {}
  description = "map of rule files {tenant=file}"
}

variable "auth_enabled" {
  default = "true"
}

variable "cassandra" {}

variable "alertmanager_url" {
  default = ""
}

