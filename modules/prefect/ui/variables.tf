variable "name" {}

variable "namespace" {}

variable "image" {
  default = "prefecthq/ui:0.12.6"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8080
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

variable "PREFECT_SERVER__GRAPHQL_URL" {
  description = "http://localhost:4200/graphql"
}

