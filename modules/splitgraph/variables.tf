variable "name" {
  default = "splitgraph"
}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 5432
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "splitgraph/engine:0.3.9-postgis"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "POSTGRES_USER" {}
variable "POSTGRES_PASSWORD" {}
variable "POSTGRES_DB" {}

variable "SG_S3_HOST" {
  default = null
}
variable "SG_S3_PORT" {
  default = null
}
variable "SG_S3_SECURE" {
  default = null
}
variable "SG_S3_BUCKET" {
  default = null
}
variable "SG_S3_KEY" {
  default = null
}
variable "SG_S3_PWD" {
  default = null
}
variable "SG_LOGLEVEL" {
  default = "INFO"
}

variable "sgconfig" {
  default = null
}

