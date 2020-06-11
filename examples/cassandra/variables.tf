variable "name" {
  default = "cassandra"
}

variable "namespace" {
  default = "cassandra-example"
}

variable "replicas" {
  default = 3
}

variable "storage_class_name" {
  default = "cephfs"
}
