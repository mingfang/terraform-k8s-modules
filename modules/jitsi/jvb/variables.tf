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
      name = "tcp"
      port = 4443
    },
    {
      name     = "udp"
      port     = 10000
      protocol = "UDP"
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/jvb"
}

variable "overrides" {
  default = {}
}

variable "NAT_HARVESTER_PUBLIC_ADDRESS" {}
variable "XMPP_AUTH_DOMAIN" {
  default = "auth"
}
variable "XMPP_INTERNAL_MUC_DOMAIN" {
  default = "internal-muc"
}

variable "XMPP_SERVER" {}

variable "JVB_AUTH_USER" {
  default = "jvb"
}
variable "JVB_AUTH_PASSWORD" {
  default = "passw0rd"
}
variable "JVB_BREWERY_MUC" {
  default = "jvbbrewery"
}
variable "JVB_PORT" {
  default = 10000
}
variable "JVB_TCP_HARVESTER_DISABLED" {
  default = "true"
}
variable "JVB_TCP_PORT" {
  default = 4443
}
variable "JVB_STUN_SERVERS" {
  default = "stun.l.google.com:19302,stun1.l.google.com:19302,stun2.l.google.com:19302"
}
variable "JVB_ENABLE_APIS" {
  default = "rest,colibri,xmpp"
}
variable "JICOFO_AUTH_USER" {
  default = "focus"
}
variable "TZ" {
  default = "America/New_York"
}