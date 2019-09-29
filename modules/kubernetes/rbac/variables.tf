variable "name" {}

variable "namespace" {
  default = null
}

variable "cluster_role_rules" {
  default = null
}

variable "role_rules" {
  default = null
}

variable "overrides" {
  default = {}
}