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

variable "config_file" {
  default     = null
  description = "path to config.yml, e.g. $${path.module}/config.yml"
}