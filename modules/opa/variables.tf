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
      port = 443
    },
  ]
}

variable "image" {
  default = "openpolicyagent/opa:0.18.0"
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

variable "log-level" {
  default = "info"
}

variable "secret_name" {
  description = "secret containing TLS certificate"
}

variable "policies_config_map" {
  description = "Rego policy files"
}

