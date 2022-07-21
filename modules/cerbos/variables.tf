variable "name" {}

variable "namespace" {}

variable "image" {
  default = "ghcr.io/cerbos/cerbos:0.19.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 3592
    },
    {
      name = "grpc"
      port = 3593
    },
  ]
}

variable "command" {
  default = null
}
variable "args" {
  default = null
}

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "config_map" {
  default = null
}
variable "policies_config_map" {
  default = null
}
variable "schemas_config_map" {
  default = null
}

variable "pvc" {
  default = null
}