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
      name = "tchannel"
      port = 14267
    },
    {
      name = "http"
      port = 14268
    },
    {
      name = "zipkin"
      port = 9411
    },
  ]
}

variable "image" {
  default = "jaegertracing/jaeger-collector:1.9.0"
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

variable "config_map_name" {}
