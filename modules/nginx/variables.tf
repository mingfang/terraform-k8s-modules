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
      port = 80
    },
  ]
}

variable "image" {
  default = "nginx:1.17.8"
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

// optional - override default.conf
variable "default-conf" {
  type    = string
  default = null
}
