variable "name" {
  default = "aws-cluster-autoscaler"
}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "k8s.gcr.io/autoscaling/cluster-autoscaler:v1.22.1"
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
