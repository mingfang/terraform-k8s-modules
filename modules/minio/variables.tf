variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9000
    },
  ]
}

variable "image" {
  default = "minio/minio:RELEASE.2020-08-04T23-10-51Z"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
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
variable "args" {
  default = []
}