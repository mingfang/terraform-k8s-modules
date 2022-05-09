variable "name" {}

variable "namespace" {}

variable "image" {
  default = "docker.elastic.co/elasticsearch/elasticsearch:7.17.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9200
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
      memory = "3Gi"
    }
    limits = {
      memory = "4Gi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "secret" {
  default     = null
  description = "secret containing ca.crt, tls.crt, and tls.key to enable TLS"
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "ES_JAVA_OPTS" {
  default = ""
}
