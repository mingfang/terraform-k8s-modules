variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "https"
      port = 8443
    },
  ]
}

variable "image" {
  default = "hashicorp/vault-k8s:0.16.0"
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

variable "AGENT_INJECT_VAULT_ADDR" {}

variable "AGENT_INJECT_LOG_LEVEL" {
  default = "info"
}

variable "AGENT_INJECT_VAULT_IMAGE" {
  default = "hashicorp/vault:1.10.2"
}

