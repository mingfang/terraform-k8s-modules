variable "name" {}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8530
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "arangodb/arangodb"
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

variable "cluster-agency-endpoints" {
  type = list(string)
}

variable "jwt-secret-keyfile" {}
