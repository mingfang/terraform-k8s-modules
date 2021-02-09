variable "name" {
  default = "cloudbeaver"
}

variable "namespace" {
  default = "cloudbeaver-example"
}

variable "replicas" {
  default = 1
}

variable "storage_class_name" {
  default = "cephfs"
}