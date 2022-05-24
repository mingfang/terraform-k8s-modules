variable "name" {}

variable "namespace" {}

variable "image" {
  default = "codercom/code-server:4.3.0"
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
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

variable "additional_containers" {
  default = []
}

variable "pvc" {
  default = null
}
