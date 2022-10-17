variable "name" {
  default = "vpa-recommender"
}

variable "namespace" {
  default = "kube-system"
}

variable "image" {
  default = "k8s.gcr.io/autoscaling/vpa-recommender:0.12.0"
}

variable "replicas" {
  default = 1
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
      cpu    = "200m"
      memory = "1000Mi"
    }
    requests = {
      cpu    = "50m"
      memory = "500Mi"
    }
  }
}

variable "overrides" {
  default = {}
}
