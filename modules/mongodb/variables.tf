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
  default = "mongo:5.0.6"
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

variable "node_selector" {
  default = null
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "1Gi"
    }
    limits = {
      memory = "4Gi"
    }
  }
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "MONGO_INITDB_ROOT_USERNAME" {
  default = ""
}

variable "MONGO_INITDB_ROOT_PASSWORD" {
  default = ""
}

variable "MONGO_INITDB_DATABASE" {
  default = ""
}

variable "replica_set" {
  default     = "rs0"
  description = "replica set name"
}

variable "keyfile_secret" {
  description = "secret with keyfile key, value must be base64 encoded"
}
