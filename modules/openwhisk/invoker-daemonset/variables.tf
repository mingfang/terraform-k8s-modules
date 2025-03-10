variable "name" {}

variable "namespace" {}

variable image {
  default = "openwhisk/invoker:71b7d56"
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

variable "KAFKA_HOSTS" {}