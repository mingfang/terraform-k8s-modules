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
    {
      name = "http-console"
      port = 9001
    },
  ]
}

variable "image" {
  default = "minio/minio:RELEASE.2021-08-25T00-41-18Z.hotfix.fa57120f2"
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
  default = null
}

variable "create_buckets" {
  default = []
}