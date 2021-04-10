variable "name" {}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9999
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "semitechnologies/contextionary:en0.16.0-v1.0.2"
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
      memory = "500Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "OCCURRENCE_WEIGHT_LINEAR_FACTOR" {
  default = 0.75
}

variable "EXTENSIONS_STORAGE_MODE" {
  default = "weaviate"
}

variable "EXTENSIONS_STORAGE_ORIGIN" {

}

variable "NEIGHBOR_OCCURRENCE_IGNORE_PERCENTILE" {
  default = 5
}

variable "ENABLE_COMPOUND_SPLITTING" {
  default = false
}
