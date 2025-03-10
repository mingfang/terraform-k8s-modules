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

variable "args" {
  default = []
}

variable "env" {
  default = []
}
variable "env_from" {
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

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "storage" {
  default = null
}

variable "storage_class_name" {
  default = null
}

variable "volume_claim_template_name" {
  default = "pvc"
}


variable "minio_access_key" {
  default = null
}

variable "minio_secret_key" {
  default = null
}

variable "create_buckets" {
  default = []
}

variable "policies_configmap" {
  default = null
}
