variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {}
variable "storage" {}

variable "annotations" {
  default = {}
}

variable "mount_options" {
  default = []
}

variable "nfs_server" {}
