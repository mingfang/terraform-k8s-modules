variable "name" {
  default = "meilisearch"
}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 7700
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "getmeili/meilisearch:v0.26.0"
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