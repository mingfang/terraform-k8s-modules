variable "name" {
  default = "elasticsearch"
}

variable "namespace" {
  default = "elasticsearch-example"
}

variable "replicas" {
  default = 3
}

variable "storage_class_name" {
  default = "cephfs"
}
