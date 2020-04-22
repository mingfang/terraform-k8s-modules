variable "name" {}

variable "namespace" {}

variable "image" {
  default = "getsentry/symbolicator:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 3021
    },
  ]
}


variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}