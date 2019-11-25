variable "name" {}

variable "namespace" {
  default = null
}

variable image {
  default = "grafana/promtail:v1.0.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  type    = map
  default = null
}

variable "overrides" {
  default = {}
}

variable "loki_url" {}

variable "config_file" {
  default = ""
}
