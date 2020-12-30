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
  default = "matomo:3.14.1"
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

variable "pvc_name" {}

variable "MATOMO_DATABASE_HOST" {}
variable "MATOMO_DATABASE_DBNAME" {
  default = null
}
variable "MATOMO_DATABASE_USERNAME" {}
variable "MATOMO_DATABASE_PASSWORD" {}