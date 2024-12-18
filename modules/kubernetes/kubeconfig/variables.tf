variable "name" {
}

variable "namespace" {
}

variable "cluster" {
}

variable "server" {
}

variable "cluster_role_rules" {
  default = []
}

variable "role_rules" {
  default = []
}

variable "cluster_role_refs" {
  type = list(object({
    api_group = string
    kind      = string
    name      = string
  }))
  default = []
}

variable "role_refs" {
  type = list(object({
    api_group = string
    kind      = string
    name      = string
  }))
  default = []
}
