variable "name" {}

variable "namespace" {
  default = null
}

variable "annotations" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "port" {
  default = 8081
}

variable "image" {
  default = "jupyterhub/k8s-hub:0.8.2"
}

variable "overrides" {
  default = {}
}

variable "config_map" {}
variable "secret_name" {}
variable "proxy_api_service_host" {}
variable "proxy_api_service_port" {}
variable "proxy_public_service_host" {}
variable "proxy_public_service_port" {}