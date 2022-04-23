variable "name" {}

variable "namespace" {}

variable image {
  default = "docker.vectorized.io/vectorized/redpanda:v21.11.14"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "proxy"
      port = 8082
    },
    {
      name = "client"
      port = 9092
    },
    {
      name = "registry"
      port = 8081
    },
    {
      name = "admin"
      port = 9644
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

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}
