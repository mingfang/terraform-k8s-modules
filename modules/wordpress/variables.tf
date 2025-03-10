variable "name" {}

variable "namespace" {
  default = null
}

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
  default = "wordpress"
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

variable "WORDPRESS_DB_HOST" {}

variable "WORDPRESS_DB_USER" {}

variable "WORDPRESS_DB_PASSWORD" {}

variable "WORDPRESS_DB_NAME" {}

variable "WORDPRESS_TABLE_PREFIX" {
  default = null
}
variable "WORDPRESS_DEBUG" {
  default = null
}
variable "WORDPRESS_CONFIG_EXTRA" {
  default = null
}
