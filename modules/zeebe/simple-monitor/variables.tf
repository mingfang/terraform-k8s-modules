variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name : "http"
      port : 8082
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
  default = "camunda/zeebe-simple-monitor:0.19.0"
}

variable "overrides" {
  default = {}
}

variable "ZEEBE_CLIENT_BROKER_CONTACTPOINT" {}

variable "ZEEBE_CLIENT_SECURITY_PLAINTEXT" {
  default = true
}
variable "ZEEBE_CLIENT_WORKER_HAZELCAST_CONNECTION" {}
