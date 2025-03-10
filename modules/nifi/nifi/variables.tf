variable "name" {}

variable "namespace" {
  default = null
}

variable "env" {
  default = []
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

variable "image" {
  default = "apache/nifi:latest"
}

variable "overrides" {
  default = {}
}