variable "name" {}

variable "namespace" {}

variable "image" {
  default = "prefecthq/server:0.12.6"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 4201
    },
  ]
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

variable "PREFECT_SERVER__DATABASE__CONNECTION_URL" {}
variable "PREFECT_SERVER__HASURA__HOST" {}
variable "PREFECT_SERVER__HASURA__PORT" {}
variable "PREFECT_SERVER__HASURA__ADMIN_SECRET" {
  default = ""
}
