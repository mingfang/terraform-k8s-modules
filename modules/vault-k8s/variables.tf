variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "https"
      port = 443
    },
  ]
}

variable "image" {
  default = "hashicorp/vault-k8s:0.10.0"
}

variable "image_leader_election" {
  default = "k8s.gcr.io/leader-elector:0.4"
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
  default = "vault:1.7.0"
}

