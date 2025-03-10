variable "name" {}

variable "namespace" {}

variable "image" {
  default = "prefecthq/server:0.12.6"
}

variable "replicas" {
  default = 1
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

variable "PREFECT_SERVER__HASURA__HOST" {}
variable "PREFECT_SERVER__HASURA__PORT" {}
variable "PREFECT_SERVER__HASURA__ADMIN_SECRET" {
  default = ""
}
variable "PREFECT_SERVER__SERVICES__SCHEDULER__SCHEDULER_LOOP_SECONDS" {
  default = 10
  description = "run scheduler every X seconds"
}
