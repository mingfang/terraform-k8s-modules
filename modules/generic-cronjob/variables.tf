// Required variables
variable "image" {
  type = string
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "schedule" {
  type = string
}

// Optional variables
variable "annotations" {
  type = map(any)
  default = {}
}

variable "args" {
  type = list(string)
  default = []
}

variable "backoff_limit" {
  type    = number
  default = null
}

variable "cluster_role_refs" {
  type = list(object({
    api_group = string
    kind      = string
    name      = string
  }))
  default = []
}

variable "cluster_role_rules" {
  default = []
}

variable "command" {
  type = list(string)
  default = []
}

variable "concurrency_policy" {
  type    = string
  default = null
}

variable "configmap" {
  default = null
}

variable "configmap_mount_path" {
  type    = string
  default = "/config"
}

variable "dns_config" {
  default = null
}

variable "dns_policy" {
  default = null
}

variable "env" {
  default = []
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

variable "env_map" {
  type = map(any)
  default = {}
}

variable "failed_jobs_history_limit" {
  type    = number
  default = null
}

variable "host_ipc" {
  default = null
}

variable "host_network" {
  default = null
}

variable "host_pid" {
  default = null
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

variable "overrides" {
  default = {}
}

variable "post_start_command" {
  type = list(string)
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

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "restart_policy" {
  type    = string
  default = null
}

variable "role_rules" {
  default = []
}

variable "security_context" {
  default = null
}

variable "service_account_name" {
  type    = string
  default = null
}

variable "starting_deadline_seconds" {
  type    = number
  default = null
}

variable "successful_jobs_history_limit" {
  type    = number
  default = null
}

variable "tolerations" {
  default = []
}

variable "ttl_seconds_after_finished" {
  type    = number
  default = null
}

variable "volumes" {
  default = []
}
