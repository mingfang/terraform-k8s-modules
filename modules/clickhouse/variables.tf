variable "name" {
  type    = string
  default = "clickhouse"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "clickhouse/clickhouse-server:22.12.2.25"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  type    = list
  default = [
    {
      name = "http"
      port = 8123
    },
    {
      name = "tcp"
      port = 9000
    },
  ]
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
      cpu    = "500m"
      memory = "1Gi"
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

variable "storage" {
  type    = string
  default = null
}

variable "storage_class" {
  type    = string
  default = null
}

variable "volume_claim_template_name" {
  type=string
  default = "pvc"
}

variable "mount_path" {
  type    = string
  default = "/var/lib/clickhouse"
  description = "pvc mount path"
}
