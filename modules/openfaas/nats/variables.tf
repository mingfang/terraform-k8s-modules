variable "name" {}

variable "namespace" {}

variable "image" {
  default = "nats-streaming:0.22.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "client"
      port = 4222
    },
    {
      name = "monitoring"
      port = 8222
    },
    {
      name = "metrics"
      port = 7777
    },
  ]
}

variable "resources" {
  default = {
    requests = {
      cpu    = "50m"
      memory = "120Mi"
    }
  }
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

variable "metrics_image" {
  default = "synadia/prometheus-nats-exporter:0.6.2"
}

variable "cluster_id" {}

