variable "name" {
  default     = "dashboard-metrics-scraper"
  description = "do not change"
}

variable "namespace" {}

variable "image" {
  default = "kubernetesui/metrics-scraper:v1.0.6"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8000
    },
  ]
  description = "do not change"
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {}
}

variable "overrides" {
  default = {}
}
