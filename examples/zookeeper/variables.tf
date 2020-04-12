variable "name" {
  default = "zookeeper"
}

variable "namespace" {
  default = "zookeeper-example"
}

variable "replicas" {
  default = 3
}

variable "storage" {
  default = "1Gi"
}

variable "storage_class" {
  default = "cephfs"
}