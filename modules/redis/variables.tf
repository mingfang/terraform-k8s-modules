variable "name" {}

variable "namespace" {}

variable "image" {
  default = "redis:4.0.6-alpine"
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 6379
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "pvc_name" {
  default = null
}