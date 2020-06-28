variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name : "http"
      port : 8080
    },
  ]
}

variable "annotations" {
  default = {}
}

variable "env" {
  default = []
}

variable "image" {
  default = "camunda/zeebe-http-worker:0.22.0"
}

variable "overrides" {
  default = {}
}

variable "ZEEBE_CLIENT_BROKER_CONTACTPOINT" {
  default = "127.0.0.1:26500"
}
variable "ZEEBE_CLIENT_SECURITY_PLAINTEXT" {
  default = true
}
variable "ZEEBE_WORKER_DEFAULTNAME" {
  default = "http-worker"
}
variable "ZEEBE_WORKER_DEFAULTTYPE" {
  default = "http"
}
