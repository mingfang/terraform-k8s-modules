variable "name" {}

variable "namespace" {}

variable image {
  default = "quay.io/cloudhut/kowl:master-ab6caaa"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default     = null
  description = "configmap with config.yml key"
}
