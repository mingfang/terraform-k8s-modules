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
      name = "http"
      port = 9102
    },
    {
      name     = "statsd-tcp"
      port     = 9125
      protocol = "TCP"
    },
    {
      name     = "statsd-udp"
      port     = 9125
      protocol = "UDP"
    },
  ]
}

variable "image" {
  default = "prom/statsd-exporter:v0.12.2"
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}