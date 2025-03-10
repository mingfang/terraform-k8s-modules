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
      name = "https"
      port = 8443
    },
  ]
}

variable "image" {
  default = "hotelsdotcom/kube-graffiti:0.8.5"
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

variable "secret_name" {
  description = "secret containeing TLS certificate"
}

variable "rules" {
  description = "kube-griffiti rules"
}

variable "rbac_cluster_role_rules" {
  default     = []
  description = "RBAC cluster role rules;  Ensure permission to execute kube-griffiti rules"
}

variable "log_level" {
  default = "info"
}

variable "check_existing" {
  default = false
}


