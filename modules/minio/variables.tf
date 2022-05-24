variable "name" {}

variable "namespace" {}

variable "image" {
  default = "minio/minio:RELEASE.2021-08-05T22-01-19Z"
}

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

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}


variable "minio_access_key" {}
variable "minio_secret_key" {}
variable "args" {
  default = []
}

variable "create_buckets" {
  default = []
}