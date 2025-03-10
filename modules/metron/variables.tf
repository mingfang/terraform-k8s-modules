variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "port" {
  default = 80
}

variable "image" {
  default = "registry.rebelsoft.com/metron"
}

variable "overrides" {
  default = {}
}