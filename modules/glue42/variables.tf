variable "name" {}

variable "namespace" {}

variable "image" {
  default = "registry.rebelsoft.com/glue42-workspace"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 3000
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {}
}

variable "overrides" {
  default = {}
}
