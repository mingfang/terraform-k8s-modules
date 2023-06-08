variable "name" {}

variable "namespace" {}

variable "image" {
  default = "rabbitmq:3.10.7-management"
}

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
    },
    {
      name = "stream"
      port = 5552
    }
  ]
}

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}
variable "env_from" {
  default = null
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
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

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "mount_path" {
  default = "/data"
  description = "pvc mount path"
}

variable "RABBITMQ_ERLANG_COOKIE" {}