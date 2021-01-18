variable "name" {}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8529
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "arangodb/arangodb:3.7.6"
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

variable "cluster-agency-endpoints" {
  type = list(string)
}

variable "jwt-secret-keyfile" {}
