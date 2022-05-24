variable "name" {}

variable "namespace" {}

variable "image" {
  default = "kubernetesui/dashboard:v2.5.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9090
    },
  ]
}

variable "args" {
  default = ""
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {}
}

variable "overrides" {
  default = {}
}
