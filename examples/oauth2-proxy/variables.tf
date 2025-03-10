variable "name" {
  default = "oauth2-proxy"
}

variable "namespace" {
  default = "oauth2-proxy-example"
}

variable "replicas" {
  default = 1
}

variable "client_id" {}
variable "client_secret" {}
variable "issuer_url" {}
