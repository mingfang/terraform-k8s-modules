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
  default = "openproject/community:11.2.2"
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

variable "pvc_name" {
  description = "Volume for /var/openproject/assets"
}

variable "DATABASE_URL" {
  description = "postgres://postgres:p4ssw0rd@db/openproject"
}

variable "USE_PUMA" {
  default = "true"
}

variable "IMAP_ENABLED" {
  default = "false"
}

variable "RAILS_CACHE_STORE" {
  default     = null
  description = "memcache"
}
variable "OPENPROJECT_CACHE__MEMCACHE__SERVER" {
  default     = null
  description = "cache:11211"
}
variable "OPENPROJECT_RAILS__RELATIVE__URL__ROOT" {
  default = null
}
