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
      port = 3100
    },
  ]
}

variable "image" {
  default = "grafana/loki:v1.3.0"
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

variable "config_file" {
  default = ""
}

variable "cassandra" {}
