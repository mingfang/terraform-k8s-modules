variable "name" {}

variable "namespace" {}

variable "replicas" {}
variable "storage" {}

variable "annotations" {
  default = {}
}

variable "mount_options" {
  default = []
}

variable "user" {}
variable "secret_name" {}
variable "secret_namespace" {}

variable "monitors" {
  type = list
}

variable "path" {
  default = "/"
}
