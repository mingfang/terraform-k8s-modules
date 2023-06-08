variable "name" {
  default = "query-service"
}

variable "namespace" {}

variable "image" {
  default = "datafuselabs/databend-query:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8000
    },
    {
      name = "admin"
      port = 8080
    },
    {
      name = "metrics"
      port = 7070
    },
    {
      name = "msql"
      port = 3307
    },
    {
      name = "clickhouse"
      port = 8124
    },
    {
      name = "flight"
      port = 9090
    },
  ]
}

variable "command" {
  default = ["/databend-query"]
}
variable "args" {
  default = []
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
      cpu    = "250m"
      memory = "64Mi"
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

variable "mount_path" {
  default = "/data"
  description = "pvc mount path"
}

variable "META_ENDPOINTS" {
}
