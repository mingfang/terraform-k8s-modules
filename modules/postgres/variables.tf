variable "name" {
  default = "postgres"
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
  default = "postgres:12.1"
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
variable "PGDATA" {
	default = "/data"
}
