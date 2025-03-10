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
      name = "dummy"
      port = 80
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/jicofo"
}

variable "overrides" {
  default = {}
}

variable "ENABLE_AUTH" {
  default = "1"
}

variable "XMPP_DOMAIN" {
  default = "meet"
}
variable "XMPP_AUTH_DOMAIN" {
  default = "auth"
}
variable "XMPP_INTERNAL_MUC_DOMAIN" {
  default = "internal-muc"
}
variable "XMPP_SERVER" {}

variable "JICOFO_COMPONENT_SECRET" {
  default = "s3cr37"
}
variable "JICOFO_AUTH_USER" {
  default = "focus"
}
variable "JICOFO_AUTH_PASSWORD" {
  default = "passw0rd"
}
variable "JVB_BREWERY_MUC" {
  default = "jvbbrewery"
}
variable "JIGASI_BREWERY_MUC" {
  default = "jigasibrewery"
}

variable "TZ" {
  default = "America/New_York"
}