variable "name" {
  default = "superset"
}

variable "namespace" {
  default = "superset-example"
}

variable "replicas" {
  default = 1
}

variable "storage_class_name" {
  default = "cephfs"
}