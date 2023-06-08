variable "name" {
  default = "dashboard"
}

variable "namespace" {}

variable "image" {
  default = "quay.io/nuclio/dashboard:1.1.11-amd64"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8070
    },
  ]
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

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "NUCLIO_BUSYBOX_CONTAINER_IMAGE" {
  default = "busybox:1.31"
}
variable "NUCLIO_DASHBOARD_REGISTRY_URL" {
  description = "used for pushing(build time)"
}
variable "NUCLIO_DASHBOARD_RUN_REGISTRY_URL" {
  description = "used for pulling(run time)"
}
variable "NUCLIO_DASHBOARD_IMAGE_NAME_PREFIX_TEMPLATE" {
  default = "function-"
  description = "prefix function image names"
}
variable "NUCLIO_CONTAINER_BUILDER_KIND" {
  default = "kaniko"
}
variable "NUCLIO_KANIKO_CONTAINER_IMAGE" {
  default = "gcr.io/kaniko-project/executor:v1.8.1"
}
variable "NUCLIO_KANIKO_INSECURE_PUSH_REGISTRY" {
  default = "false"
}
variable "NUCLIO_KANIKO_PUSH_IMAGES_RETRIES" {
  default = "3"
}
variable "NUCLIO_KANIKO_JOB_DELETION_TIMEOUT" {
  default = "30m"
}
variable "NUCLIO_MONITOR_DOCKER_DAEMON" {
  default = "true"
}
variable "NUCLIO_MONITOR_DOCKER_DAEMON_INTERVAL" {
  default = "5s"
}
variable "NUCLIO_MONITOR_DOCKER_DAEMON_MAX_CONSECUTIVE_ERRORS" {
  default = "5"
}
