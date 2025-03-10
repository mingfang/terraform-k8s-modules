variable "name" {
  default = "openwhisk-whisk.config"
}
variable "namespace" {}

variable "whisk_api_host_name" {}
variable "whisk_api_host_port" {}
variable "whisk_api_host_proto" {
  default = "https"
}

