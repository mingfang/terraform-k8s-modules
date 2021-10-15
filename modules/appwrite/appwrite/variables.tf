variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 80
    },
  ]
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

variable "pvc_functions" {
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
variable "_APP_USAGE_STATS" {
  default     = "disabled"
  description = "enabled or disabled"
}
variable "_APP_INFLUXDB_HOST" {}
variable "_APP_INFLUXDB_PORT" {
  default = 8086
}
variable "_APP_STORAGE_ANTIVIRUS" {
  default = "disabled"
}

