variable "name" {}

variable "namespace" {}

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

variable "image" {
  default = "trinodb/trino:374"
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
  default = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}

variable "catalog_configmap" {
  default = null
}
variable "config_configmap" {
  default = null
}
