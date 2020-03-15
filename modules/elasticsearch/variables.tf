variable "name" {}

variable "namespace" {
  default = null
}

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
  default = "docker.elastic.co/elasticsearch/elasticsearch:7.6.1"
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

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "heap_size" {
  default = "4g"
}
