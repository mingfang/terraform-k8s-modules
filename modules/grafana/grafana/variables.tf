variable "name" {}

variable "namespace" {}

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
  default = "grafana/grafana:7.3.1"
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

variable "pvc_name" {}

variable "grafana_ini_config_map_name" {
  default = null
}

variable "dashboards_config_map_name" {
  default = null
}

variable "datasources_config_map_name" {
  default = null
}