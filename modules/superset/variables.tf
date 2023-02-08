variable "name" {}

variable "namespace" {}

variable "image" {
  default = "apache/superset:2.0.1"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8088
    },
  ]
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

variable "config_configmap" {
  default = null
}

variable "datasources_configmap" {
  default = null
}
