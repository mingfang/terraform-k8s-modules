variable "name" {}

variable "namespace" {}

variable "image" {
  default = "postgres:12.1"
}

variable "replicas" {
  default     = 1
  description = "hardcoded to 1"
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 5432
    },
  ]
}

variable "command" {
  default = null
}
variable "args" {
  default = null
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
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default     = null
  description = "keys must be *.sql files used for db initialization"
}

variable "storage" {}
variable "storage_class" {}
variable "volume_claim_template_name" {
  default = "pvc"
}

variable "POSTGRES_USER" {
  default = null
}
variable "POSTGRES_PASSWORD" {
  default = null
}
variable "POSTGRES_DB" {
  default = null
}
