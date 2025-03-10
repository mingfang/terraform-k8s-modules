variable "name" {}

variable "namespace" {}

variable "image" {
  default = "ghcr.io/postalserver/postal:2.1.1"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 5000
    },
  ]
}

variable "command" {
  default = ["postal", "web-server"]
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

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "secret" {
  default = null
}

variable "pvc" {
  default = null
}