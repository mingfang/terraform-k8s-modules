variable "name" {
  default = "kong"
}

variable "namespace" {}

variable "image" {
  default = "kong:2.8.1"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8000
    },
    {
      name = "https"
      port = 8443
    },
  ]
}

variable "command" {
  default = []
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
  default = "/data"
  description = "pvc mount path"
}
