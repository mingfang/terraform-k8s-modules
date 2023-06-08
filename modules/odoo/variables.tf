variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "odoo:14.0"
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8069
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

variable "additional_containers" {
  default = []
}

variable "pvc" {
  default = null
}

variable "HOST" {}
variable "PORT" {}
variable "USER" {}
variable "PASSWORD" {}
