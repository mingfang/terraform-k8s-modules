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
      name = "zookeeper"
      port = 2181
    }
  ]
}

variable "image" {
  default = "gcr.io/etcd-development/zetcd:v0.0.5"
}

variable "overrides" {
  default = {}
}

variable "etcd" {}
