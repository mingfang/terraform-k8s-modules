variable "name" {
  default = "server"
}

variable "namespace" {}

variable "image" {
  default = "openmetadata/server:0.12.2-preview.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "port1"
      port = 8585
    },
    {
      name = "port2"
      port = 8586
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
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}
variable "env_from" {
  default = []
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

