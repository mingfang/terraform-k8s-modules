variable "name" {}

variable "namespace" {}

variable "image" {
  default = "trinodb/trino:389"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "env" {
  default = []
}

variable "env_from" {
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
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "catalog_configmap" {
  default = null
}

variable "config_configmap" {
  default = null
}
