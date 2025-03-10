variable "name" {}

variable "namespace" {}

variable "image" {
  default = "querybook/querybook:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8080
    },
  ]
}

variable "command" {
  default = null
}
variable "args" {
  default = ["./querybook/scripts/bundled_docker_run_web", "--initdb"]
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
      memory = "800Mi"
    }
  }
}

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "pvc" {
  default = null
}

variable "FLASK_SECRET_KEY" {}
variable "DATABASE_CONN" {}
variable "REDIS_URL" {}
variable "ELASTICSEARCH_HOST" {}