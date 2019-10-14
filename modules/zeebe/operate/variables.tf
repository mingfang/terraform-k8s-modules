variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name : "http"
      port : 8080
    },
  ]
}

variable "image" {
  default = "camunda/operate:1.1.0"
}

variable "overrides" {
  default = {}
}

variable "CAMUNDA_OPERATE_ELASTICSEARCH_HOST" {
}
variable "CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_HOST" {
}
variable "CAMUNDA_OPERATE_ZEEBE_BROKERCONTACTPOINT" {
}
