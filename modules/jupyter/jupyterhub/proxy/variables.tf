variable "name" {}

variable "namespace" {
  default = null
}

variable "annotations" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8000
    },
    {
      name = "api"
      port = 8001
    },
  ]
}

variable "image" {
  default = "jupyterhub/configurable-http-proxy:3.0.0"
}

variable "overrides" {
  default = {}
}

variable "secret_name" {}
variable "hub_service_host" {}
variable "hub_service_port" {}