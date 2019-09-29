variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 3
}

variable "ports" {
  default = [
    {
      name = "peer"
      port = 2380
    },
    {
      name = "client"
      port = 2379
    },
  ]
}

variable "image" {
  default = "gcr.io/etcd-development/etcd:v3.3.13"
}

variable "overrides" {
  default = {}
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

