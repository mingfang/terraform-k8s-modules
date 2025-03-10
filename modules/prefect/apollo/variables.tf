variable "name" {}

variable "namespace" {}

variable "image" {
  default = "prefecthq/apollo:0.12.6"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 4200
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

variable "HASURA_API_URL" {
  description = "http://hasura:3000/v1alpha1/graphql"
}
variable "PREFECT_API_URL" {
  description = "http://graphql:4201/graphql/"
}
variable "PREFECT_API_HEALTH_URL" {
  description = "http://graphql:4201/health"
}
variable "PREFECT_SERVER__TELEMETRY__ENABLED" {
  default = true
}
