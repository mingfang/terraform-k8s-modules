variable "name" {}

variable "namespace" {}

variable "image" {
  default = "quay.io/coreos/etcd:v3.5.11"
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
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "storage" {}

variable "storage_class" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "ETCD_AUTO_COMPACTION_MODE" {
  default = "revision"
}
variable "ETCD_AUTO_COMPACTION_RETENTION" {
  default = "1000"
}
variable "ETCD_QUOTA_BACKEND_BYTES" {
  default = "4294967296"
}
