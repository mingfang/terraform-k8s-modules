variable "name" {
  type    = string
  default = "meta"
}

variable "namespace" {
  type = string
}

variable "image" {
  default = "supabase/postgres-meta:v0.56.1"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ports" {
  type    = list
  default = [
    {
      name = "tcp"
      port = 8080
    },
  ]
}

variable "command" {
  type    = list(string)
  default = []
}

variable "args" {
  type    = list(string)
  default = []
}

variable "env" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "env_map" {
  type    = map
  default = {}
}

variable "env_file" {
  type    = string
  default = null
}

variable "env_from" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
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
  type    = string
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
  type=string
  default = "/data"
  description = "pvc mount path"
}
