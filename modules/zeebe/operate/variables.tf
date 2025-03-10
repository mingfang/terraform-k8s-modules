variable "name" {}

variable "namespace" {}

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
  default = "camunda/operate:1.3.3"
}

variable "overrides" {
  default = {}
}

variable "CAMUNDA_OPERATE_ELASTICSEARCH_URL" {
}
variable "CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_URL" {
}
variable "CAMUNDA_OPERATE_ZEEBE_GATEWAYADDRESS" {
}
