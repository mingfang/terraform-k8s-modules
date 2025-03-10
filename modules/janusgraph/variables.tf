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
      name = "gremlin"
      port = 8182
    }
  ]
}

variable "image" {
  default = "janusgraph/janusgraph:0.4"
}

variable "env" {
  default = []
}

variable "overrides" {
  default = {}
}
