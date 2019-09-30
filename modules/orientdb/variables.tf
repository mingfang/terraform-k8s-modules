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
      name = "http"
      port = 2480
    },
    {
      name = "binary"
      port = 2424
    },
  ]
}

variable "image" {
  default = "orientdb:3.0.23"
}

variable "env" {
  default = []
}

variable "args" {
  default = ""
}

variable "overrides" {
  default = {}
}

variable "storage_class" {}

variable "storage" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "ORIENTDB_ROOT_PASSWORD" {}

variable "ORIENTDB_OPTS_MEMORY" {
  default = "-Xms4G -Xmx4G"
}

variable "distributed" {
  default = "true"
}