variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 3
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 9200
    },
  ]
}

variable image {
  default = "docker.elastic.co/elasticsearch/elasticsearch:7.16.3"
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

variable "node_selector" {
  default = null
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

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "ES_JAVA_OPTS" {
  default = ""
}
