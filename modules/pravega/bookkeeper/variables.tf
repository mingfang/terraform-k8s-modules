variable "name" {}

variable "namespace" {}

variable "image" {
  default = "pravega/bookkeeper:0.11.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 3181
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "125m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable pvc {
  default = "pvc"
}

variable storage {}

variable "storage_class" {}

variable "ZK_URL" {}

