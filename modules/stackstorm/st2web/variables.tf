variable "name" {}

variable "namespace" {}

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
  default = "stackstorm/st2web:3.6.0"
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

variable "ST2_AUTH_URL" {}
variable "ST2_API_URL" {}
variable "ST2_STREAM_URL" {}
