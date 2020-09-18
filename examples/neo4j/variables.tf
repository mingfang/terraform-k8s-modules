variable "name" {
  default = "neo4j"
}

variable "namespace" {
  default = "neo4j-example"
}

variable "replicas" {
  default = 3
}

variable "storage_class_name" {
  default = "cephfs"
}
