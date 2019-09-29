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
      name = "5222"
      port = 5222
    },
    {
      name = "5347"
      port = 5347
    },
    {
      name = "5280"
      port = 5280
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/prosody"
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
variable "XMPP_DOMAIN" {
  default = "meet"
}
variable "XMPP_AUTH_DOMAIN" {
  default = "auth"
}
variable "XMPP_GUEST_DOMAIN" {
  default = "guest"
}
variable "XMPP_MUC_DOMAIN" {
  default = "muc"
}
variable "XMPP_INTERNAL_MUC_DOMAIN" {
  default = "internal-muc"
}
variable "XMPP_MODULES" {
  default = ""
}
variable "XMPP_MUC_MODULES" {
  default = ""
}
variable "XMPP_INTERNAL_MUC_MODULES" {
  default = ""
}
variable "JICOFO_COMPONENT_SECRET" {
  default = "s3cr37"
}
variable "JICOFO_AUTH_USER" {
  default = "focus"
}
variable "JICOFO_AUTH_PASSWORD" {
  default = "passw0rd"
}
variable "JVB_AUTH_USER" {
  default = "jvb"
}
variable "JVB_AUTH_PASSWORD" {
  default = "passw0rd"
}
variable "JIGASI_XMPP_USER" {
  default = "jigasi"
}
variable "JIGASI_XMPP_PASSWORD" {
  default = "passw0rd"
}

variable "TZ" {
  default = "America/New_York"
}