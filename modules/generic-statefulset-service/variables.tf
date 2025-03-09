variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "image" {
  type = string
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ports" {
  type    = list(any)
  default = []
}

variable "ports_map" {
  type    = map(any)
  default = {}
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
    name = string,
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

variable "config_files" {
  type    = list(string)
  default = null
}

variable "config_files_mount_path" {
  type    = string
  default = "/config"
}

variable "_lifecycle" {
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

variable "init_containers" {
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

variable "security_context" {
  default = null
}

variable "storage" {
  type    = string
  default = null
}

variable "storage_class" {
  type    = string
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
