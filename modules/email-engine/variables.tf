variable "name" {}

variable "namespace" {}

variable "image" {
  default = "andris9/emailengine:v2"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 3000
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

variable "configmap" {
  default = null
}

variable "pvc" {
  default = null
}

variable "EENGINE_REDIS" {
  description = "redis://127.0.0.1:6379/8"
}