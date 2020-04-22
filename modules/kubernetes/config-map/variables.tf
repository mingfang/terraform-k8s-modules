variable "name" {}

variable "namespace" {}

variable "labels" {
  default = null
}

variable "from-dir" {
  default = null
}

variable "from-files" {
  default = []
}

variable "from-file" {
  default = null
}

variable "from-map" {
  default = {}
}
