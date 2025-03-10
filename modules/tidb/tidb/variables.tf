variable "name" {
  default = "tidb"
}

variable "namespace" {}

variable "image" {
  default = "pingcap/tidb:v6.4.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp1"
      port = 4000
    },
    {
      name = "tcp2"
      port = 10080
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

variable "pd" {}
