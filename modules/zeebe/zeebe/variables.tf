variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 3
}

variable "ports" {
  default = [
    {
      name = "gateway"
      port = 26500
    },
    {
      name = "command"
      port = 26501
    },
    {
      name = "internal"
      port = 26502
    },
  ]
}

variable "image" {
  default = "camunda/zeebe:0.21.1"
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

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "JAVA_TOOL_OPTIONS" {
  default = "-Xms1024m -Xmx1024m"
}

variable "ZEEBE_LOG_LEVEL" {
  default = "info"
}

variable "elasticsearch_url" {
  default = ""
}