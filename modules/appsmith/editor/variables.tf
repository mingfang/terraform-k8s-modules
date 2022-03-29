variable "name" {}

variable "namespace" {}

variable "image" {
  default = "appsmith/appsmith-editor:v1.6.16"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 80
    },
  ]
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

variable "nginx_conf_template" {
  default = null
}

variable "APPSMITH_SENTRY_DSN" {
  default = ""
}
variable "APPSMITH_SMART_LOOK_ID" {
  default = ""
}
variable "APPSMITH_OAUTH2_GOOGLE_CLIENT_ID" {
  default = ""
}
variable "APPSMITH_OAUTH2_GITHUB_CLIENT_ID" {
  default = ""
}
variable "APPSMITH_MARKETPLACE_ENABLED" {
  default = ""
}
variable "APPSMITH_SEGMENT_KEY" {
  default = ""
}
variable "APPSMITH_OPTIMIZELY_KEY" {
  default = ""
}
variable "APPSMITH_ALGOLIA_API_ID" {
  default = ""
}
variable "APPSMITH_ALGOLIA_SEARCH_INDEX_NAME" {
  default = ""
}
variable "APPSMITH_ALGOLIA_API_KEY" {
  default = ""
}
variable "APPSMITH_CLIENT_LOG_LEVEL" {
  default = ""
}
variable "APPSMITH_GOOGLE_MAPS_API_KEY" {
  default = ""
}
variable "APPSMITH_TNC_PP" {
  default = ""
}
variable "APPSMITH_VERSION_ID" {
  default = ""
}
variable "APPSMITH_VERSION_RELEASE_DATE" {
  default = ""
}
variable "APPSMITH_INTERCOM_APP_ID" {
  default = ""
}
variable "APPSMITH_MAIL_ENABLED" {
  default = ""
}
variable "APPSMITH_DISABLE_TELEMETRY" {
  default = ""
}

