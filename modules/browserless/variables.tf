variable "name" {}

variable "namespace" {}

variable "image" {
  default = "browserless/chrome:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 3000
    },
  ]
}

variable "command" {
  default = null
}
variable "args" {
  default = []
}

variable "env" {
  default = []
}
variable "env_from" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "pvc" {
  default = null
}

variable "mount_path" {
  default     = "/data"
  description = "pvc mount path"
}

