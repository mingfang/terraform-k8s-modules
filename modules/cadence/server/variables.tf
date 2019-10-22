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
      name : "frontend"
      port : 7933
    },
    {
      name : "history"
      port : 7934
    },
    {
      name : "matching"
      port : 7935
    },
    {
      name : "worker"
      port : 7939
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

variable "LOG_LEVEL" {
  default = "info"
}

variable "NUM_HISTORY_SHARDS" {
  default = 512
}

