variable "name" {
  default = "prefect"
}

variable "namespace" {
  default = "prefect-example"
}

variable "replicas" {
  default = 1
}

variable "storage_class_name" {
  default = "cephfs"
}