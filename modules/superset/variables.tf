variable "name" {}

variable "namespace" {}

variable "image" {
  default = "apache/superset:48f3eb427300faf5aa0a5ba22b20997324df3d2d"
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
