variable "name" {
  type    = string
  default = "{{name}}"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "{{image}}"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ports" {
  type    = list
  default = {{ ports  }}
}

variable "command" {
  type    = list(string)
  default = {{ command }}
}

variable "args" {
  type    = list(string)
  default = {{ args }}
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

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "configmap_mount_path" {
  type = string
  default = "{{ configmap_mount_path }}"
}

variable "post_start_command" {
  type    = list(string)
  default = {{ post_start_command }}
}

variable "pvc" {
  type    = string
  default = null
}

variable "mount_path" {
  type    = string
  default = "/data"
  description = "pvc mount path"
}

{% if not use_rbac -%}
variable "service_account_name" {
  type    = string
  default = null
}
{%- endif %}
