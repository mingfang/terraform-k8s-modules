variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  type = list(any)
  default = [
    {
      name = "http"
      port = 80
    },
  ]
}

variable "image" {
  default = "gitlab/gitlab-runner:latest"
}

variable "env" {
  type    = list(any)
  default = []
}

variable "annotations" {
  type    = map(any)
  default = null
}

variable "node_selector" {
  type    = map(any)
  default = null
}

variable "overrides" {
  default = {}
}

variable "gitlab_url" {}

variable "registration_token" {}
