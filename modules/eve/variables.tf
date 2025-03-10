variable "name" {}

variable "namespace" {}

variable "image" {
  default = "mingfang/eve:latest"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 5000
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "MONGO_URI" {
  description = "mongodb://root:example@mongo:27017/"
}

variable "domain_config" {
  default     = null
  description = "configmap with domain.json key"
}
