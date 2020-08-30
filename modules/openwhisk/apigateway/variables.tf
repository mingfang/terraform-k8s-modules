variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "api"
      port = 9000
    },
    {
      name = "mgmt"
      port = 8080
    },
  ]
}

variable image {
  default = "openwhisk/apigateway:1.0.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "whisk_config_name" {}
variable "REDIS_HOST" {}
variable "REDIS_PORT" {}
