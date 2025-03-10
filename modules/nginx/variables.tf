variable "name" {}

variable "namespace" {}

variable "image" {
  default = "nginx:1.21.6"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 80
    },
  ]
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

// optional - override nginx.conf
variable "nginx-conf" {
  type    = string
  default = null
}

// optional - override default.conf
variable "default-conf" {
  type    = string
  default = null
}
