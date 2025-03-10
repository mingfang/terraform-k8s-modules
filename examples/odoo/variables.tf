variable "name" {
  default = "odoo"
}

variable "namespace" {
  default = "odoo-example"
}

variable "replicas" {
  default = 1
}

variable "storage_class" {
  default = "cephfs"
}