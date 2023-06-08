variable "name" {}

variable "namespace" {}

variable "annotations" {
  default = {}
}

variable "image" {
  default = "tooljet/tooljet-server-ce:v1.14.0"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 3000
    },
  ]
}

variable "env" {
  default = []
}


variable "resources" {
  default = {
    requests = {
      cpu    = "125m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "SERVE_CLIENT" {
  default = "false"
}

variable "PG_DB" {}
variable "PG_USER" {}
variable "PG_HOST" {}
variable "PG_PASS" {}
variable "LOCKBOX_MASTER_KEY" {
  description = "32 byte hexadecimal string."
}
variable "SECRET_KEY_BASE" {
  description = "64 byte hexadecimal string to encrypt session cookies."
}
variable "TOOLJET_HOST" {
  description = "the public URL of ToolJet client"
}
variable "CHECK_FOR_UPDATES" {
  default     = "0"
  description = "Self-hosted version of ToolJet pings our server to fetch the latest product updates every 24 hours. You can disable this by setting the value of CHECK_FOR_UPDATES environment variable to 0"
}
variable "COMMENT_FEATURE_ENABLE" {
  default     = "true"
  description = "enable/disable the feature that allows you to add comments on the canvas."
}