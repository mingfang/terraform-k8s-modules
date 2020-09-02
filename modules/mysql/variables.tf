variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 3306
    },
  ]
}

variable "image" {
  default = "mysql:8.0.19"
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

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "TZ" {
  default = "UTC"
}

variable "default-authentication-plugin" {
  default = "caching_sha2_password"
  description = "caching_sha2_password or mysql_native_password."
}

variable MYSQL_USER {}

variable MYSQL_PASSWORD {}

variable MYSQL_DATABASE {}

variable "MYSQL_ROOT_PASSWORD" {}

variable "MYSQL_ROOT_HOST" {
  default = "%"
}
