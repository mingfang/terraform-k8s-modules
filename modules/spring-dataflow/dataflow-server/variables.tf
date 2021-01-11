variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 9393
    },
  ]
}

variable "image" {
  default = "springcloud/spring-cloud-dataflow-server:2.7.0-SNAPSHOT"
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

variable "SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI" {}
