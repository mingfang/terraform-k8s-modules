variable "name" {}

variable "namespace" {}

variable "image" {
  default = "semitechnologies/weaviate:1.15.3"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
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
      cpu    = "500m"
      memory = "300Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "QUERY_DEFAULTS_LIMIT" {
  default = 100
}
variable "AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED" {
  default = true
}
variable "PERSISTENCE_DATA_PATH" {
  default = "/data"
}
variable "ENABLE_MODULES" {
  default = ""
}
variable "DEFAULT_VECTORIZER_MODULE" {
  default = ""
}

variable "LOG_LEVEL" {
  default = "info"
}
