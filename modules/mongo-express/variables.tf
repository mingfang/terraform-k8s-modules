variable "name" {}

variable "namespace" {}

variable "image" {
  default = "registry.rebelsoft.com/mongo-express:latest"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8081
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

variable "ME_CONFIG_MONGODB_ADMINUSERNAME" {
  default = ""
}
variable "ME_CONFIG_MONGODB_ADMINPASSWORD" {
  default = ""
}
variable "ME_CONFIG_MONGODB_URL" {
  description = "mongodb://root:example@mongo:27017/"
}
