variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 3
}

variable "ports" {
  default = [
    {
      name = "ysql"
      port = 5433
    },
    {
      name = "ycql"
      port = 9042
    },
    {
      name = "yedis"
      port = 6379
    },
    {
      name = "yb-tserver"
      port = 9000
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

variable "tserver_master_addrs" {}
