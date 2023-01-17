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
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}
variable "env_from" {
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
      cpu    = "1"
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

variable "storage" {
  default = null
}

variable "storage_class" {
  default = null
}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "mount_path" {
  default = "/data"
  description = "pvc mount path"
}

variable "ES_JAVA_OPTS" {
  default = ""
}
