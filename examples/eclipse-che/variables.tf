variable "name" {
  default = "che"
}

variable "namespace" {
  default = "eclipse-example"
}

variable "user_storage" {
  default = "1Gi"
}

variable "storage_class_name" {
  default = "cephfs"
}
