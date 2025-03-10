variable "name" {}

variable "namespace" {}

variable "image" {
  default = "registry.rebelsoft.com/spark"
}

variable "replicas" {
  default = 1
}

variable "env" {
  default = []
}



variable "overrides" {
  default = {}
}

variable "spark_master_port" {
  default = 7077
}

variable "spark_master_webui_port" {
  default = 8080
}