variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 3
}

variable "ports" {
  default = [
    {
      name = "ui"
      port = 7000
    },
    {
      name = "rpc"
      port = 7100
    },
  ]
}

variable "image" {
  default = "yugabytedb/yugabyte:2.2.0.0-b80"
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

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}
