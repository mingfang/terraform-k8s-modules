variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "webdriver"
      port = 4444
    },
  ]
}

variable "image" {
  default = "dosel/zalenium"
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

variable "pvc_name" {
  default = null
}

variable "user_secret_name" {
  default = null
}

variable "ZALENIUM_KUBERNETES_NODE_SELECTOR" {
  default = null
}
variable "ZALENIUM_KUBERNETES_TOLERATIONS" {
  default = null
}
variable "ZALENIUM_KUBERNETES_CPU_REQUEST" {
  default = "250m"
}
variable "ZALENIUM_KUBERNETES_CPU_LIMIT" {
  default = "1000m"
}
variable "ZALENIUM_KUBERNETES_MEMORY_REQUEST" {
  default = "500Mi"
}
variable "ZALENIUM_KUBERNETES_MEMORY_LIMIT" {
  default = "2Gi"
}
variable "DESIRED_CONTAINERS" {
  default = 1
}
variable "MAX_DOCKER_SELENIUM_CONTAINERS" {
  default = 10
}
variable "SELENIUM_IMAGE_NAME" {
  default = "elgalu/selenium"
}
variable "VIDEO_RECORDING_ENABLED" {
  default = "true"
}
variable "SCREEN_WIDTH" {
  default = "1440"
}
variable "SCREEN_HEIGHT" {
  default = "900"
}
variable "MAX_TEST_SESSIONS" {
  default = 1
}
variable "NEW_SESSION_WAIT_TIMEOUT" {
  default = "600000"
}
variable "DEBUG_ENABLED" {
  default = "false"
}
variable "SEND_ANONYMOUS_USAGE_INFO" {
  default = "true"
}
variable "TZ" {
  default = null
}
variable "KEEP_ONLY_FAILED_TESTS" {
  default = null
}
variable "RETENTION_PERIOD" {
  default = null
}
variable "CONTEXT_PATH" {
  default = null
}
variable "NGINX_MAX_BODY_SIZE" {
  default = null
}
variable "TIME_TO_WAIT_TO_START" {
  default = null
}