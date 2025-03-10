variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "appwrite/appwrite:0.13.4"
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

variable "_APP_ENV" {
  default     = "production"
  description = "development or production(default)"
}

variable "_APP_REDIS_HOST" {}
variable "_APP_REDIS_PORT" {
  default = "6379"
}
variable "_APP_MAINTENANCE_INTERVAL" {
  default = 86400
}
variable "_APP_MAINTENANCE_RETENTION_EXECUTION" {
  default = 1209600
}
variable "_APP_MAINTENANCE_RETENTION_ABUSE" {
  default = 86400
}
variable "_APP_MAINTENANCE_RETENTION_AUDIT" {
  default = 1209600
}
