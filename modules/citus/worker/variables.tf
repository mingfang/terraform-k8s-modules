variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 5432
    },
  ]
}

variable "image" {
  default = "citusdata/citus:12.1"
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
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "coordinator" {
  description = "coordinator hostname"
}

variable "secret" {
  description = "secret containing the password"
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}
