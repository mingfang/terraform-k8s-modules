variable "name" {}

variable "namespace" {}

variable "image" {
  default = "dpage/pgadmin4:5.6"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 80
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

variable "pvc_name" {
  default = null
}

variable "PGADMIN_DEFAULT_EMAIL" {}

variable "PGADMIN_DEFAULT_PASSWORD" {}