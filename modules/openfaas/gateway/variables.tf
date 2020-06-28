variable "name" {}

variable "namespace" {}

variable "image" {
  default = "openfaas/gateway:0.18.17"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    }
  ]
}

variable "resources" {
  default = {
    requests = {
      cpu    = "50m"
      memory = "120Mi"
    }
  }
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "functions_provider_url" {}

variable "read_timeout" {
  default = "65s"
}
variable "write_timeout" {
  default = "65s"
}
variable "upstream_timeout" {
  default     = "60s"
  description = "Must be smaller than read/write_timeout"
}
variable "direct_functions" {
  default = true
}
variable "function_namespace" {
  default     = null
  description = "default to same namespace as gateway"
}

variable "direct_functions_suffix" {
  default     = null
  description = "default to <function_namespace>.svc.cluster.local"
}
variable "faas_nats_address" {
  default = ""
}
variable "faas_nats_port" {
  default = ""
}
variable "faas_nats_cluster_name" {
  default = ""
}
variable "faas_nats_channel" {
  default = ""
}
variable "scale_from_zero" {
  default = true
}
variable "max_idle_conns" {
  default = 1024
}
variable "max_idle_conns_per_host" {
  default = 1024
}

