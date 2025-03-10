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
  default = "semitechnologies/ner-transformers:dbmdz-bert-large-cased-finetuned-conll03-english"
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
      cpu    = "1000m"
      memory = "3000Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "ENABLE_CUDA" {
  default = "0"
}