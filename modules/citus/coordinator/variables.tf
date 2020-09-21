variable "name" {}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 5432
    },
  ]
}

variable "image" {
  default = "citusdata/citus:9.4.0"
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

variable "secret" {
  description = "secret containing the password"
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}
