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

variable "nfs_server" {}
