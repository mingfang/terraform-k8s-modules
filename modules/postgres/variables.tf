variable "name" {
  type    = string
  default = "postgres"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "postgres:12.1"
}

variable "replicas" {
  type        = number
  default     = 1
}

variable "ports" {
  type    = list
  default = [{ name = "tcp", port = 5432 }]
}

variable "command" {
  type    = list(string)
  default = null
}

variable "args" {
  type    = list(string)
  default = null
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
      cpu    = "100m"
      memory = "128Mi"
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
  default     = null
  description = "keys must be *.conf files used for /etc/postgresql"
}

variable "configmap_mount_path" {
  type = string
  default = "/etc/postgresql"
}

variable "post_start_command" {
  type    = list(string)
  default = null
}

variable "storage" {
  type    = string
  default = null
}

variable "storage_class" {
  type=string
  default = null
}

variable "volume_claim_template_name" {
  type    = string
  default = "pvc"
}

variable "mount_path" {
  type        = string
  default     = "/data"
  description = "pvc mount path"
}
