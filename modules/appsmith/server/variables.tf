variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "image" {
  default = "appsmith/appsmith-server:v1.7.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "APPSMITH_REDIS_URL" {}
variable "APPSMITH_MONGODB_URI" {}
variable "APPSMITH_ENCRYPTION_PASSWORD" {}
variable "APPSMITH_ENCRYPTION_SALT" {}

