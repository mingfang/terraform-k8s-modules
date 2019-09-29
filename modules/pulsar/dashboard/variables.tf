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
      port = 80
    }
  ]
}

variable "image" {
  default = "apachepulsar/pulsar-dashboard"
}

variable "overrides" {
  default = {}
}

variable "SERVICE_URL" {}