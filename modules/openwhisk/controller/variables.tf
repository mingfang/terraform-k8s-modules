variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "controller"
      port = 8080
    },
  ]
}

variable image {
  default = "openwhisk/controller:71b7d56"
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
variable "db_secret_name" {}
variable "db_config_name" {}

variable "KAFKA_HOSTS" {}
