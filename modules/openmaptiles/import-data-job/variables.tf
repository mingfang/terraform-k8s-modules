variable "name" {}

variable "namespace" {}

variable "image" {
  default = "openmaptiles/import-data:6.1"
}

variable "env" {}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}
