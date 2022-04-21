variable "name" {}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "semitechnologies/weaviate:1.12.2"
}

variable "env" {
  default = []
}

variable "annotations" {
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

variable "CONTEXTIONARY_URL" {
  default = null
}
variable "TRANSFORMERS_INFERENCE_API" {
  default = null
}
variable "QNA_INFERENCE_API" {
  default = null
}
variable "NER_INFERENCE_API" {
  default = null
}
variable "SPELLCHECK_INFERENCE_API" {
  default = null
}
variable "QUERY_DEFAULTS_LIMIT" {
  default = 25
}
variable "AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED" {
  default = true
}
variable "PERSISTENCE_DATA_PATH" {
  default = "/data"
}
variable "DEFAULT_VECTORIZER_MODULE" {
  default = ""
}
variable "ENABLE_MODULES" {
  default = ""
}
