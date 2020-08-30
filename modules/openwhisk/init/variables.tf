variable "name" {
  default = "init"
}
variable "namespace" {}

variable "whisk_config_name" {}
variable "whisk_secret_name" {}
variable "db_config_name" {}
variable "db_secret_name" {}
variable "WHISK_API_GATEWAY_HOST_V2" {
  description = "http://openwhisk-apigateway.default.svc.cluster.local:9000/v2"
}
