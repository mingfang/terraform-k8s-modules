variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "minio/minio"
}

variable "env" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
  default = null
}

variable "node_selector" {
  type    = map
  default = null
}

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable "minio_access_key" {}
variable "minio_secret_key" {}