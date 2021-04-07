variable "name" {}

variable "namespace" {}

variable image {
  default = "grafana/promtail:2.2.1"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "loki_url" {}

variable "config_file" {
  default = ""
}

variable "tenant_id" {
  default = ""
}
