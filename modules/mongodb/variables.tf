variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 27017
    },
  ]
}

variable "image" {
  default = "mongo"
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

variable "MONGO_INITDB_ROOT_USERNAME" {}

variable "MONGO_INITDB_ROOT_PASSWORD" {}

variable "MONGO_INITDB_DATABASE" {}