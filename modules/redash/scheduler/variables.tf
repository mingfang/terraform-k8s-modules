variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
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

variable "QUEUES" {
  default = "celery"
}
variable "WORKERS_COUNT" {
  default = 1
}
