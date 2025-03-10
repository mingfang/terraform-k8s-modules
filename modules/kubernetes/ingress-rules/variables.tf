variable "name" {}

variable "namespace" {
  default = null
}

variable "annotations" {
  type    = map
  default = {}
}

variable "ingress_class" {
  default = null
}

variable "rules" {}

variable "tls" {
  default = null
}

variable "overrides" {
  default = {}
}
