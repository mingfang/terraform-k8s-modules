variable "name" {}

variable "namespace" {}

variable "image" {
  default = "preset/superset"
}

variable "replicas" {
  default = 1
}

variable ports {
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

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "config_secret_name" {
  default = null
}
