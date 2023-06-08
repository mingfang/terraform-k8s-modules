variable "name" {}

variable "namespace" {}

variable "annotations" {
  default = {}
}

variable "image" {
  default = "tooljet/tooljet-client-ce:v1.14.0"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 80
    },
  ]
}

variable "env" {
  default = []
}


variable "resources" {
  default = {
    requests = {
      cpu    = "125m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "SERVER_HOST" {}
