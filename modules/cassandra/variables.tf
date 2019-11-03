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
      name = "intra-node"
      port = 7000
    },
    {
      name = "intra-node-tls"
      port = 7001
    },
    {
      name = "jmx"
      port = 7199
    },
    {
      name = "rpc"
      port = 9160
    },
    {
      name = "cql"
      port = 9042
    },
  ]
}

variable "image" {
  default = "cassandra:3.11.5"
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
