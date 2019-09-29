variable "name" {}

variable "namespace" {
  default = null
}

variable "env" {
  default = []
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "registry.rebelsoft.com/spark"
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