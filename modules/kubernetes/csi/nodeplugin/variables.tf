variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {}

variable "command" {
  default = []
}

variable "args" {
  default = []
}

variable "overrides" {
  default = {}
}
