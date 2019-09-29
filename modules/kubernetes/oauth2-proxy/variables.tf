variable "name" {}

variable "namespace" {
  default = null
}

variable "OAUTH2_PROXY_CLIENT_ID" {}

variable "OAUTH2_PROXY_CLIENT_SECRET" {}

variable "OAUTH2_PROXY_COOKIE_SECRET" {}

variable "cookie_domain" {
  default = ""
}

