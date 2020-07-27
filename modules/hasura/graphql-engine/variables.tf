variable "name" {}

variable "namespace" {}

variable "image" {
  default = "hasura/graphql-engine:v1.3.0"
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

variable "HASURA_GRAPHQL_DATABASE_URL" {}

variable "HASURA_GRAPHQL_ENABLE_CONSOLE" {
  default = "false"
}
