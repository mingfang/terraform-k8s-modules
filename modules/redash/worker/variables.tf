variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "redash/redash:8.0.0.b32245"
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
  default = "scheduled_queries,schemas"
}
variable "WORKERS_COUNT" {
  default = 1
}
