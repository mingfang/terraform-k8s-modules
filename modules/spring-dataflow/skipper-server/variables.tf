variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 7577
    },
  ]
}

variable "image" {
  default = "springcloud/spring-cloud-skipper-server:latest"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "25m"
      memory = "80Mi"
    }
    limits = {
      memory = "2Gi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "RABBITMQ_HOST" {}
variable "RABBITMQ_PORT" {
  default = 5672
}
variable "RABBITMQ_USERNAME" {}
variable "RABBITMQ_PASSWORD" {}
variable "RABBITMQ_VIRTUAL_HOST" {
  default = "/"
}
