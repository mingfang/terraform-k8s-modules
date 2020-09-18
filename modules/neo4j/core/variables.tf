variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 7474
    },
    {
      name = "bolt"
      port = 7687
    },
  ]
}

variable "image" {
  default = "neo4j:4.1.1-enterprise"
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

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "NEO4J_ACCEPT_LICENSE_AGREEMENT" {
  default = "NO"
}

