variable "name" {
  default = "pd"
}

variable "namespace" {}

variable "image" {
  default = "pingcap/pd:v6.4.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "client"
      port = 2379
    },
    {
      name = "peer"
      port = 2380
    },
  ]
}

variable "command" {
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
