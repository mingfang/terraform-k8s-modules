variable "name" {}

variable "namespace" {}

variable "cluster_role_rules" {
  default = null
}

variable "role_rules" {
  default = null
}

variable "overrides" {
  default = {}
}