variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "vnc"
      port = 5900
    },
  ]
}

variable "image" {
  default = "selenium/node-chrome-debug:3.141"
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

variable "HUB_HOST" {}

variable "HUB_PORT" {
  default = 4444
}
