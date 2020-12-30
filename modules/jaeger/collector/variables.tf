variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http-jaeger"
      port = 14268
    },
    {
      name = "http-admin"
      port = 14269
    },
    {
      name = "http-zipkin"
      port = 9411
    },
    {
      name = "grpc"
      port = 14250
    },
  ]
}

variable "image" {
  default = "jaegertracing/jaeger-collector:1.20.0"
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
