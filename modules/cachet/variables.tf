variable "name" {}

variable "namespace" {}

variable "image" {
  default = "cachethq/docker:latest"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8000
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

variable "DB_HOST" {}
variable "DB_DATABASE" {}
variable "DB_USERNAME" {}
variable "DB_PASSWORD" {}
