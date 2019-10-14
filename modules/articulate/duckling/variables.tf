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
      port = 8000
    },
  ]
}

variable "image" {
  default = "samtecspg/duckling:0.1.6.0"
}

variable "env" {
  default = []
}

variable "overrides" {
  default = {}
}