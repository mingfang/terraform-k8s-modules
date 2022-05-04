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
  default = []
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

variable "additional_containers" {
  default = []
}

variable "pvc" {
  default = null
}
