variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "appwrite/appwrite:0.10.4"
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

variable "pvc_uploads" {
  default = ""
}

variable "_APP_ENV" {
  default     = "production"
  description = "development or production(default)"
}

variable "_APP_REDIS_HOST" {}
variable "_APP_REDIS_PORT" {
  default = "6379"
}
variable "_APP_DB_HOST" {}
variable "_APP_DB_PORT" {
  default = "6379"
}
variable "_APP_DB_SCHEMA" {}
variable "_APP_DB_USER" {}
variable "_APP_DB_PASS" {}