variable "name" {}

variable "namespace" {}

variable "image" {
  default = "registry.rebelsoft.com/trafficserver"
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

variable "host_port" {
  default = null
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {}
}

variable "overrides" {
  default = {}
}
