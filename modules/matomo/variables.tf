variable "name" {
  type    = string
  default = "matomo"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "matomo:4.15.1"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ports" {
  type    = list
  default = [{ name = "http", port = 80 }]
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
  type    = list(object({
    prefix = string,
    secret_ref = object({
      name = string,
    })
  }))
  default = []
}

variable "annotations" {
  type    = map
  default = {}
}

variable "image_pull_secrets" {
  type    = list(object({ name = string, value = string }))
  default = []
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

variable "configmap_mount_path" {
  type = string
  default = "/config"
}

variable "post_start_command" {
  type    = list(string)
  default = null
}

variable "pvc" {
  type    = string
  default = null
}

variable "pvc_mount_path" {
  type    = string
  default = "/var/www/html/config"
  description = "pvc mount path"
}

variable "pvc_user" {
type    = string
default = "www-data:www-data"
}


variable "sidecars" {
  default = []
}

variable "extra_volumes" {
  type = list(object({
    volume = object({
      name = string
      empty_dir = object({})
      mount_path = string
    })
  }))
  default = []
}
