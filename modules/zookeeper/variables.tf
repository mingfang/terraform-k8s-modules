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
      name = "client"
      port = 2181
    },
    {
      name = "server"
      port = 2888
    },
    {
      name = "leader-election"
      port = 3888
    },
  ]
}

variable "image" {
  default = "zookeeper"
}

variable "env" {
  default = []
}

variable "overrides" {
  default = {}
}

variable "storage_class" {}

variable "storage" {}

variable "volume_claim_template_name" {
  default = "pvc"
}
