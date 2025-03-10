variable "name" {
  type    = string
  default = "pageserver"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "neondatabase/neon:latest"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ports" {
  type    = list
  default = [{ name = "http", port = 8080 }, { name = "postgres", port = 5432 },]
}

variable "command" {
  type    = list(string)
  default = []
}

variable "args" {
  type    = list(string)
  default = []
}

variable "env" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "env_map" {
  type    = map
  default = {}
}

variable "env_file" {
  type    = string
  default = null
}

variable "env_from" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
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
  type    = string
  default = null
}


variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "configmap_mount_path" {
  type = string
  default = "/config"
}

variable "post_start_command" {
  type    = list(string)
  default = null
}

variable "storage" {
  type=string
  default = null
}

variable "storage_class" {
  type=string
  default = null
}

variable "volume_claim_template_name" {
  type=string
  default = "pvc"
}

variable "mount_path" {
  type    = string
  default     = "/data"
  description = "pvc mount path"
}

variable "BROKER_ENDPOINT" {
  type        = string
  description = "http://storage_broker:50051"
}

variable "S3_ENDPOINT" {
  type        = string
  default     = ""
  description = "http://minio:9000"
}
variable "BUCKET_NAME" {
  type    = string
  default = "neon"
}
variable "BUCKET_REGION" {
  type    = string
  default = "us-east-1"
}
variable "BUCKET_PREFIX" {
  type    = string
  default = "pageserver"
}
