variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {}
variable "storage" {}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "mount_options" {
  type    = "list"
  default = []
}

variable "user" {}
variable "secret_name" {}
variable "secret_namespace" {}

variable "monitors" {
  type = "list"
}

variable "path" {
  default = "/"
}
