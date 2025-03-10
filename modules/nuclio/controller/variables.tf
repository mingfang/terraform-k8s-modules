variable "name" {
  default = "controller"
}

variable "namespace" {}

variable "image" {
  default = "quay.io/nuclio/controller:1.1.11-amd64"
}

variable "replicas" {
  default = 1
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
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

variable "NUCLIO_CONTROLLER_CRON_TRIGGER_CRON_JOB_IMAGE_NAME" {
  default = "appropriate/curl:latest"
}
variable "NUCLIO_CONTROLLER_FUNCTION_MONITOR_INTERVAL" {
  default = "3m"
}
variable "NUCLIO_CONTROLLER_FUNCTION_OPERATOR_NUM_WORKERS" {
  default = "4"
}
variable "NUCLIO_CONTROLLER_FUNCTION_EVENT_OPERATOR_NUM_WORKERS" {
  default = "2"
}
variable "NUCLIO_CONTROLLER_PROJECT_OPERATOR_NUM_WORKERS" {
  default = "2"
}
variable "NUCLIO_CONTROLLER_API_GATEWAY_OPERATOR_NUM_WORKERS" {
  default = "2"
}
variable "NUCLIO_CONTROLLER_RESYNC_INTERVAL" {
  default = "0"
}
