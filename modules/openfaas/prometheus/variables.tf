variable "name" {}

variable "namespace" {}

variable "image" {
  default = "prom/prometheus:v2.11.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9090
    }
  ]
}

variable "resources" {
  default = {
    requests = {
      cpu    = "50m"
      memory = "512Mi"
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

variable "function_namespace" {
  default = null
}
