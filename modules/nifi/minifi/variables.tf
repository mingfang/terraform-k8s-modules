variable "name" {}

variable "namespace" {
  default = null
}

variable image {
  default = "apache/nifi-minifi:0.5.0"
}


variable "node_selector" {
  type    = map
  default = null
}

variable "overrides" {
  default = {}
}

variable "c2_hostname" {}