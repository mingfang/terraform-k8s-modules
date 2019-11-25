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
      port = 3000
    },
  ]
}

variable "image" {
  default = "grafana/grafana:master"
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

variable "datasources_file" {
  default = ""
}

variable "dashboards_file" {
  default = ""
}
