variable "name" {}

variable "namespace" {}

variable "image" {
  default = "openfaas/queue-worker:0.11.0"
}

variable "replicas" {
  default = 1
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
variable "faas_nats_queue_group" {
  default = "faas"
}
variable "faas_gateway_address" {}

variable "gateway_invoke" {
  default = true
}
variable "function_namespace" {
  default     = null
  description = "default to same namespace as gateway"
}

variable "faas_function_suffix" {
  default     = null
  description = "default to <function_namespace>.svc.cluster.local"
}
variable "max_inflight" {
  default = 1
}
variable "ack_wait" {
  default = "60s"
}
