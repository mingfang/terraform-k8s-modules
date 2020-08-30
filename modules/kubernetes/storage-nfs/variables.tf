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

variable "nfs_server" {}
