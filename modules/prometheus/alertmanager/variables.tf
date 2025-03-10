variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9093
    },
  ]
}

variable "image" {
  default = "prom/alertmanager:v0.21.0"
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
  default = null
}

variable "config_map" {
  default     = null
  description = "configmap with alertmanager.yml key"
}
