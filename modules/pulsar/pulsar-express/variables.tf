variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "port" {
  default = 3000
}

variable "image" {
  default = "registry.rebelsoft.com/pulsar-express"
}

variable "overrides" {
  default = {}
}

variable "PE_CONNECTION_URL" {}