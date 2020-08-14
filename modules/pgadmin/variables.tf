variable "name" {}

variable "namespace" {}

variable "image" {
  default = "dpage/pgadmin4:4.24"
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

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "PGADMIN_DEFAULT_EMAIL" {}

variable "PGADMIN_DEFAULT_PASSWORD" {}