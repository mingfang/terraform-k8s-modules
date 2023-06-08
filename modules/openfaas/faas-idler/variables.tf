variable "name" {}

variable "namespace" {}

variable "image" {
  default = "ghcr.io/openfaas/faas-idler-pro:0.4.4"
}

variable "replicas" {
  default = 1
}

variable "resources" {
  default = {
    requests = {
      cpu    = "50m"
      memory = "64Mi"
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

variable "gateway_url" {}
variable "prometheus_host" {}
variable "prometheus_port" {}

variable "inactivity_duration" {
  default = "30m"
}
variable "reconcile_interval" {
  default = "2m"
}
variable "write_debug" {
  default = true
}
