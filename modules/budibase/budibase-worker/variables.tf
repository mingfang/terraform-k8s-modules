variable "name" {}

variable "namespace" {}

variable "annotations" {
  default = {}
}

variable "image" {
  default = "budibase/worker:v1.0.98"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 4003
    },
  ]
}

variable "env" {
  default = []
}


variable "resources" {
  default = {
    requests = {
      cpu    = "125m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "APPS_URL" {}

variable "COUCH_DB_USERNAME" {}
variable "COUCH_DB_PASSWORD" {}
variable "COUCH_DB_URL" {}

variable "MINIO_URL" {}
variable "MINIO_ACCESS_KEY" {}
variable "MINIO_SECRET_KEY" {}

variable "REDIS_URL" {}
variable "REDIS_PASSWORD" {}

variable "INTERNAL_API_KEY" {}
variable "JWT_SECRET" {}
variable "LOG_LEVEL" {
  default = "info"
}
variable "SENTRY_DSN" {
  default = null
}
variable "ENABLE_ANALYTICS" {
  default = "false"
}
variable "SELF_HOSTED" {
  default = 1
}
