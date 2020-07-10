variable "name" {
  default = "hasura"
}

variable "namespace" {
  default = "hasura-example"
}

variable "replicas" {
  default = 1
}

variable "storage_class_name" {
  default = "cephfs"
}