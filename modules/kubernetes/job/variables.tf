variable "name" {}

variable "namespace" {}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable image {}

variable "env" {
  default = []
}

variable "env_from" {
  default =[]
}

variable "command" {}

variable restart_policy {
  default = "OnFailure"
}

variable backoff_limit {
  default = 4
}

variable "configmap" {
  default = null
}

variable "secret" {
  default = null
}

variable "volumes" {
  default = []
}

variable "volume_mounts" {
  default = []
}
