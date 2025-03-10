variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 11222
    },
  ]
}

variable "image" {
  default = "quay.io/infinispan/server:11.0.9.Final"
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

variable "configmap" {
  default     = null
  description = "configmap containing infinispan.xml"
}

variable "USER" {}

variable "PASS" {}