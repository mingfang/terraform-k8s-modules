variable "name" {
  default = "gotrue"
}

variable "namespace" {}

variable "image" {
  default = "supabase/gotrue:v2.40.1"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 9999
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
      cpu    = "100m"
      memory = "128Mi"
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

variable "GOTRUE_API_HOST" {
  default = "0.0.0.0"
}
