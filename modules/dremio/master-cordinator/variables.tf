variable "name" {}

variable "namespace" {}

variable "image" {
  default = "dremio/dremio-oss:21.1.1"
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

variable "pvc_name" {}

variable "extra_args" {
  default = ""
}
