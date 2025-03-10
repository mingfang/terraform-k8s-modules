variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8125
    },
  ]
}

variable "image" {
  default = "appwrite/telegraf:1.2.0"
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

variable "_APP_INFLUXDB_HOST" {}
variable "_APP_INFLUXDB_PORT" {
  default = 8086
}

