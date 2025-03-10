variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 6080
    },
    {
      name = "grpc"
      port = 5080
    },
  ]
}

variable "image" {
  default = "dgraph/dgraph:v20.03.1"
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
