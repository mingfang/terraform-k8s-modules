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
      name = "thrift"
      port = 9160
    },
    {
      name = "cql"
      port = 9042
    },
    {
      name = "rest"
      port = 10000
    },
  ]
}

variable "image" {
  default = "scylladb/scylla"
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
