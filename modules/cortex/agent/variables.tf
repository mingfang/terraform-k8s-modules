variable "name" {}

variable "namespace" {}

variable image {
  default = "grafana/agent:v0.4.0"
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

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "remote_write_url" {}

variable "config_file" {
  default = ""
}

variable "log_level" {
  default = "info"
}