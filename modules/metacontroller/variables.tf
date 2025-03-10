variable "name" {}

variable "namespace" {}

variable "image" {
  default = "metacontrollerio/metacontroller:v3.0.1"
}

variable "replicas" {
  default = 1
}


variable "ports" {
  default = [
    {
      name = "tcp"
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