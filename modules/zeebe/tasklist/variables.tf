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

variable "annotations" {
  default = {}
}

variable "env" {
  default = []
}

variable "image" {
  default = "camunda/tasklist:1.3.1"
}

variable "overrides" {
  default = {}
}

variable "CAMUNDA_TASKLIST_ELASTICSEARCH_URL" {
}
variable "CAMUNDA_TASKLIST_ZEEBEELASTICSEARCH_URL" {
}
variable "CAMUNDA_TASKLIST_ZEEBE_GATEWAYADDRESS" {
}
