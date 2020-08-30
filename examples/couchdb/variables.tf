variable "name" {
  default = "couchdb"
}

variable "namespace" {
  default = "couchdb-example"
}

variable "replicas" {
  default = 1
}

variable "storage_class_name" {
  default = "cephfs"
}
