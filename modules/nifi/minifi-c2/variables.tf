variable "name" {}

variable "namespace" {
  default = null
}

variable "env" {
  default = []
}

variable ports {
  default = [
    {
      name = "http"
      port = 10080
    },
  ]
}

variable "image" {
  default = "apache/nifi-minifi-c2:0.5.0"
}

variable "overrides" {
  default = {}
}

variable "NIFI_REST_API_URL" {}
