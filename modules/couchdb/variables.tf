variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 5984
    },
  ]
}

variable "image" {
  default = "apache/couchdb:2.3"
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

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
    limits = {
      memory = "1Gi"
    }
  }
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "NODENAME" {
  default = null
  description = "defaults to pod name"
}
variable "db_secret_name" {
  default = ""
}
variable "db_password_key" {
  default = ""
}
variable "db_username_key" {
  default = ""
}
