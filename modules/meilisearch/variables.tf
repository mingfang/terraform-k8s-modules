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
  default = "getmeili/meilisearch:v0.27.1"
}

variable "env" {
  default = []
}

variable "env_from" {
  type    = list(object({
    prefix = string,
    secret_ref = object({
      name = string,
    })
  }))
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