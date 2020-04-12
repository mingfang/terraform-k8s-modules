variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 3
}

variable "ports" {
  default = [
    {
      name = "client"
      port = 2181
    },
    {
      name = "server"
      port = 2888
    },
    {
      name = "leader-election"
      port = 3888
    },
  ]
}

variable "image" {
  default = "zookeeper:3.6.0"
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
