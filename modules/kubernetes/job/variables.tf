variable "name" {}

variable "namespace" {}

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

