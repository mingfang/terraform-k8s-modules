variable "name" {}

variable "namespace" {}

variable "image" {
  default = "dremio/dremio-oss:4.6.1"
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9047
    },
    {
      name = "client"
      port = 31010
    },
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

variable "overrides" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "100Mi"
    }
  }
}

variable "config_map" {}

variable "zookeeper" {}

variable "master-cordinator" {}