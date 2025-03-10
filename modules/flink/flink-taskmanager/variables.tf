variable "name" {}

variable "namespace" {}

variable "image" {
  default = "apache/flink:1.15.0-scala_2.12"
}

variable "replicas" {
  default = 1
}

variable "command" {
  default = null
}
variable "args" {
  default = ["taskmanager"]
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