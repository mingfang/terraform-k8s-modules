variable "name" {}

variable "namespace" {}

variable "image" {
  default = "openfaas/faas-netes:0.12.2"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    }
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

variable "function_namespace" {
  default     = null
  description = "default to same namespace as gateway"
}
variable "operator" {
  default = false
}
variable "read_timeout" {
  default = "60s"
}
variable "write_timeout" {
  default = "60s"
}
variable "image_pull_policy" {
  default = "Always"
}
variable "http_probe" {
  default = true
}
variable "set_nonroot_user" {
  default = false
}
variable "readiness_probe_initial_delay_seconds" {
  default = 2
}
variable "readiness_probe_timeout_seconds" {
  default = 1
}
variable "readiness_probe_period_seconds" {
  default = 2
}
variable "liveness_probe_initial_delay_seconds" {
  default = 2
}
variable "liveness_probe_timeout_seconds" {
  default = 1
}
variable "liveness_probe_period_seconds" {
  default = 2
}

