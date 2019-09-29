variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "ursuad/spark-ui-proxy"
}

variable "overrides" {
  default = {}
}

variable "master_host" {}

variable "master_port" {}
