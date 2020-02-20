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
      name = "grpc-int"
      port = 7080
    },
    {
      name = "http"
      port = 8080
    },
    {
      name = "grpc"
      port = 9080
    },
  ]
}

variable "image" {
  default = "dgraph/dgraph"
}

variable "env" {
  default = []
}

variable "overrides" {
  default = {}
}

variable "storage_class" {
  default = null
}

variable "storage" {
  default = null
}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "peer" {}
