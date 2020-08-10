variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8081
    },
  ]
}

variable image {
  default = "confluentinc/cp-schema-registry:5.5.1"
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

variable "overrides" {
  default = {}
}

variable SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS {}
