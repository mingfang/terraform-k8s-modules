variable "name" {}

variable "namespace" {}

variable "image" {
  default = "dremio/dremio-oss:15.0.0"
}

variable "ports" {
  default = [
    {
      name = "server"
      port = 45678
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
  default = null
}

variable "replicas" {
  default = 1
}

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "4Gi"
    }
  }
}

variable "config_map" {}

variable "zookeeper" {}
