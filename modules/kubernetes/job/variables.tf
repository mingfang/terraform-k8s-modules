variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable image {
  type = string
}

variable "annotations" {
  default = {}
}

variable "command" {
  type    = list(string)
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


variable restart_policy {
  default = "OnFailure"
}

variable backoff_limit {
  default = 4
}

variable "configmap" {
  default = null
}

variable "secret" {
  default = null
}

variable "volumes" {
  default = []
}

variable "volume_mounts" {
  default = []
}

variable "pvcs" {
  type = list(object({
    name = string
    mount_path = string
  }))
  default = []
}

variable "overrides" {
  default = {}
}
