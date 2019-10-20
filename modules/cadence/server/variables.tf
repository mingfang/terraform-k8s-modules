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
      name : "tcp"
      port : 7933
    },
  ]
}

variable "image" {
  default = "ubercadence/server:0.9.5-auto-setup"
}

variable "overrides" {
  default = {}
}

variable "CASSANDRA_SEEDS" {}

variable "BIND_ON_IP" {
  default = "0.0.0.0"
}

variable "CADENCE_CLI_DOMAIN" {
  default = "default"
}
