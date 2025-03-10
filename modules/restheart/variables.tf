variable "name" {}

variable "namespace" {}

variable "image" {
  default = "softinstigate/restheart:6.2.1"
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

variable "resources" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "MONGO_URI" {
  description = "mongodb://root:example@mongo:27017/"
}
