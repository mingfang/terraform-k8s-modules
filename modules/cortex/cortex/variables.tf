variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9009
    },
  ]
}

variable "image" {
  default = "quay.io/cortexproject/cortex:v1.1.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
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

variable "config_file" {
  default = ""
}

variable "auth_enabled" {
  default = "true"
}

variable "cassandra" {}

variable "keyspace" {
  default = "cortex"
}
