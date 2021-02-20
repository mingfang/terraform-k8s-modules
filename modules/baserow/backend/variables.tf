variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8000
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/baserow-backend:latest"
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

variable "PUBLIC_BACKEND_URL" {}
variable "PUBLIC_WEB_FRONTEND_URL" {}

variable "REDIS_HOST" {}
variable "REDIS_PORT" {
  default = null
}
variable "REDIS_USER" {
  default = ""
}
variable "REDIS_PASSWORD" {
  default = ""
}
variable "REDIS_PROTOCOL" {
  default = "redis"
}

variable "DATABASE_HOST" {}
variable "DATABASE_PORT" {
  default = null
}
variable "DATABASE_NAME" {}
variable "DATABASE_USER" {}
variable "DATABASE_PASSWORD" {}
