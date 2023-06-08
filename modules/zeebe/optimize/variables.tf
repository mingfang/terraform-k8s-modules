variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name : "http"
      port : 8090
    },
  ]
}

variable "image" {
  default = "camunda/optimize:1.3.3"
}

variable "overrides" {
  default = {}
}

variable "CAMUNDA_OPTIMIZE_ELASTICSEARCH_URL" {
}
variable "CAMUNDA_OPTIMIZE_ZEEBEELASTICSEARCH_URL" {
}
variable "CAMUNDA_OPTIMIZE_ZEEBE_GATEWAYADDRESS" {
}
