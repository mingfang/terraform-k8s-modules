variable "name" {}

variable "namespace" {
  default = null
}

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
  default = "prom/alertmanager:v0.19.0"
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

// path to config.yml, e.g. ${path.module}/config.yml
variable "config_file" {
  default = ""
}