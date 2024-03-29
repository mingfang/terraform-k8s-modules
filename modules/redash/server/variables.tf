variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 5000
    },
  ]
}

variable "image" {
  default = "redash/redash:10.0.0-beta.b49597"
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

variable "REDASH_DATABASE_URL" {}

variable "REDASH_REDIS_URL" {}

variable "REDASH_WEB_WORKERS" {
  default = 4
}
