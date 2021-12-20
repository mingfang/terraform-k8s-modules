variable "name" {
  default = "aws-cloud-provider"
}

variable "namespace" {}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "us.gcr.io/k8s-artifacts-prod/provider-aws/cloud-controller-manager:v1.22.0-alpha.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu = "200m"
    }
  }
}

variable "node_selector" {
  default = {}
}


variable "overrides" {
  default = {}
}

