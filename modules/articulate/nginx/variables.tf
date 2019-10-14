variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 80
    },
  ]
}

variable "image" {
  default = "nginx:1.15.10-alpine"
}

variable "env" {
  default = []
}

variable "overrides" {
  default = {}
}

variable "api" {}
variable "ui" {}