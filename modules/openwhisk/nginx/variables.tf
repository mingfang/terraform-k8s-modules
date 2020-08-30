variable "name" {}
variable "namespace" {}
variable "ports" {
  default = [
    {
      name = "http"
      port = 80
    }
  ]
}

variable "controller" {}
variable "apigateway" {}
