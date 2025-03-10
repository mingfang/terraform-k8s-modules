variable "name" {
  default = "aws-cloud-provider"
}

variable "namespace" {
  default = "kube-system"
}

variable "image" {
  default = "registry.k8s.io/provider-aws/cloud-controller-manager:v1.23.0-alpha.0"
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

