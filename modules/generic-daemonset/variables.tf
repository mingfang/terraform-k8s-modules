variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "image" {
  type = string
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
  default = []
}

variable "env_map" {
  type    = map(any)
  default = {}
}

variable "env_file" {
  type    = string
  default = null
}

variable "env_from" {
  type = list(object({
    prefix = string,
    secret_ref = object({
      name = string,
    })
  }))
  default = []
}

variable "annotations" {
  type    = map(any)
  default = {}
}

variable "image_pull_secrets" {
  type = list(object({
    name  = string,
    value = string
  }))
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
  type    = string
  default = "/config"
}

variable "post_start_command" {
  type    = list(string)
  default = null
}

variable "pvcs" {
  type = list(object({
    name       = string
    mount_path = string
  }))
  default = []
}

variable "pvc_user" {
  type    = string
  default = "1000"
}

variable "volumes" {
  default = []
}

variable "sidecars" {
  default = []
}

variable "tolerations" {
  default = []
}

variable "cluster_role_rules" {
  default = []
}

variable "role_rules" {
  default = []
}

variable "cluster_role_refs" {
  type = list(object({
    api_group = string
    kind      = string
    name      = string
  }))
  default = []
}

variable "host_network" {
  default = null
}
