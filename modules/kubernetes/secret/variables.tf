variable "name" {}

variable "namespace" {}

variable type {
  default     = "Opaque"
  description = "Opaque or kubernetes.io/dockerconfigjson"
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
