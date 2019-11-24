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
      name = "frontend"
      port = 7933
    },
    {
      name = "history"
      port = 7934
    },
    {
      name = "matching"
      port = 7935
    },
    {
      name = "worker"
      port = 7939
    },
  ]
}

variable "image" {
  default = "ubercadence/server:0.10.1-auto-setup"
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

variable "CASSANDRA_SEEDS" {}

// This domain will be auto registered
variable "CADENCE_CLI_DOMAIN" {
  default = "default"
}

variable "CADENCE_CLI_SHOW_STACKS" {
  default = "1"
}

variable "LOG_LEVEL" {
  default = "info"
}

variable "NUM_HISTORY_SHARDS" {
  default = 512
}

variable "RINGPOP_SEEDS" {
  default = ""
}

variable "SERVICES" {
  default = "history,matching,frontend,worker"
}

variable "SKIP_SCHEMA_SETUP" {
  default = false
}

variable "STATSD_ENDPOINT" {
  default = ""
}

variable "config_file" {
  default = ""
}
