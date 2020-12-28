variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "amqp"
      port = 5672
    },
    {
      name = "management"
      port = 15672
    },
    {
      name = "stomp"
      port = 61613
    },
    {
      name = "stomp-web"
      port = 15674
    }
  ]
}

variable "image" {
  default = "rabbitmq:3.8.9-management"
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

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "RABBITMQ_ERLANG_COOKIE" {}