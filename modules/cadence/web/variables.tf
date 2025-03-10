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
      name : "http"
      port : 8088
    },
  ]
}

variable "image" {
  default = "ubercadence/web:3.4.1"
}

variable "overrides" {
  default = {}
}

variable "CADENCE_TCHANNEL_PEERS" {}