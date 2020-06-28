variable "name" {}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "gateway"
      port = 26500
    },
    {
      name = "command"
      port = 26501
    },
    {
      name = "internal"
      port = 26502
    },
    {
      name = "monitoring"
      port = 9600
    },
    {
      name = "hazelcast"
      port = 5701
    },
  ]
}

variable "image" {
  default = "camunda/zeebe:0.23.2"
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

variable "resources" {
  default = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
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

variable "ZEEBE_BROKER_CLUSTER_REPLICATIONFACTOR" {
  default = 1
}

variable "JAVA_TOOL_OPTIONS" {
  default = ""
}

variable "ZEEBE_LOG_LEVEL" {
  default = "info"
}