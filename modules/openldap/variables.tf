variable "name" {}

variable "namespace" {}

variable "image" {
  default = "osixia/openldap:1.4.0"
}

variable "ports" {
  default = [
    {
      name = "tcp1"
      port = 389
    },
    {
      name = "tcp2"
      port = 636
    },
  ]
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "pvc" {
  default = null
}

variable "LDAP_ORGANISATION" {}
variable "LDAP_DOMAIN" {}
