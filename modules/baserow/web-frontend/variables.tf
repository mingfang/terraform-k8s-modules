variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 3000
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/baserow-web-frontend:latest"
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

variable "PRIVATE_BACKEND_URL" {}
variable "PUBLIC_BACKEND_URL" {}

variable "PUBLIC_WEB_FRONTEND_URL" {
  default = null
}
variable "INITIAL_TABLE_DATA_LIMIT" {
  default = 100
}
