variable "name" {
  default = "aws-cluster-autoscaler"
}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "registry.k8s.io/autoscaling/cluster-autoscaler:v1.28.2"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    limits = {
      cpu    = "100m"
      memory = "600Mi"
    }
    requests = {
      cpu    = "100m"
      memory = "600Mi"
    }
  }
}

variable "node_selector" {
  default = {}
}


variable "overrides" {
  default = {}
}

variable "CLUSTER_NAME" {}

variable "cordon-node-before-terminating" {
  default = true
}

variable "ignore-daemonsets-utilization" {
  default = true
}
