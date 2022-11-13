variable "name" {
  default = "meta-service"
}

variable "namespace" {}

variable "image" {
  default = "datafuselabs/databend-meta:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "metrics"
      port = 28001
    },
    {
      name = "admin"
      port = 28002
    },
    {
      name = "flight"
      port = 9191
    },
    {
      name = "raft"
      port = 28004
    },
  ]
}

variable "command" {
  default = ["/databend-meta"]
}
variable "args" {
  default = ["--single"]
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
