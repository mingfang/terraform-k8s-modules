variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 80
    },
    {
      name = "https"
      port = 443
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/web"
}

variable "overrides" {
  default = {}
}

variable "ENABLE_AUTH" {
  default = "1"
}
variable "ENABLE_GUESTS" {
  default = "1"
}
variable "ENABLE_LETSENCRYPT" {
  default = "0"
}
variable "ENABLE_HTTP_REDIRECT" {
  default = "0"
}
variable "DISABLE_HTTPS" {
  default = "1"
}
variable "JICOFO_AUTH_USER" {
  default = "focus"
}
variable "LETSENCRYPT_DOMAIN" {
  default = ""
}
variable "LETSENCRYPT_EMAIL" {
  default = ""
}

variable "XMPP_DOMAIN" {
  default = "meet"
}
variable "XMPP_AUTH_DOMAIN" {
  default = "auth"
}
variable "XMPP_BOSH_URL_BASE" {}

variable "XMPP_GUEST_DOMAIN" {
  default = "guest"
}
variable "XMPP_MUC_DOMAIN" {
  default = "muc"
}

variable "TZ" {
  default = "America/New_York"
}