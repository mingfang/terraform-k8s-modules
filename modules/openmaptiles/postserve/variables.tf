variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8090
    },
  ]
}

variable "image" {
  default = "openmaptiles/openmaptiles-tools:6.1"
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

variable "TILESET_FILE" {}
