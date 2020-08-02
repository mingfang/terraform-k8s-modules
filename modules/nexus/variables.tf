variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8081
    },
  ]
}

variable "image" {
  default = "sonatype/nexus3:3.25.1"
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

variable "pvc_name" {}