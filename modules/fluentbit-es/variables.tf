variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "fluent/fluent-bit:0.14.8"
}

variable "env" {
  type    = list(any)
  default = []
}

variable "annotations" {
  type    = map(any)
  default = null
}

variable "node_selector" {
  type    = map(any)
  default = null
}

variable "overrides" {
  default = {}
}

variable "fluent_elasticsearch_host" {}

variable "fluent_elasticsearch_port" {}
