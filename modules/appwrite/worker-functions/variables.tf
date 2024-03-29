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

variable "_APP_FUNCTIONS_TIMEOUT" {
  default = 900
}
variable "_APP_FUNCTIONS_CONTAINERS" {
  default = 10
}
variable "_APP_FUNCTIONS_CPUS" {
  default = 1
}
variable "_APP_FUNCTIONS_MEMORY" {
  default = 256
}
variable "_APP_FUNCTIONS_MEMORY_SWAP" {
  default = 256
}
variable "_APP_USAGE_STATS" {
  default     = "disabled"
  description = "enabled or disabled"
}
