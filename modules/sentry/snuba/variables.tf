variable "name" {}

variable "namespace" {}

variable "image" {
  default = "getsentry/snuba:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 1218
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

variable "SNUBA_SETTINGS" {
  default = "docker"
}
variable "CLICKHOUSE_HOST" {
}
variable "DEFAULT_BROKERS" {
  description = "Kafka URL, e.g. kafka:9092"
}
variable "REDIS_HOST" {
}
