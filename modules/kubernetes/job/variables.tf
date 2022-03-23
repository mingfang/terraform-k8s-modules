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

variable "command" {}

variable restart_policy {
  default = "OnFailure"
}

variable backoff_limit {
  default = 4
}

variable "volumes" {
  default = []
}

variable "volume_mounts" {
  default = []
}
