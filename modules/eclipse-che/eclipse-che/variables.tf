variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "eclipse/che-server:7.5.0"
}

variable "replicas" {
  default = 1
}

variable "env" {
  default = []
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
    {
      name = "metrics"
      port = 8087
    },
  ]
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
}

variable "ingress_class" {}

variable CHE_INFRA_KUBERNETES_INGRESS_DOMAIN {}

variable CHE_INFRA_KUBERNETES_SERVICE__ACCOUNT__NAME {
  default = "che-workspace"
}
variable CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT {
  default = "che-workspace"
}

variable CHE_INFRA_KUBERNETES_PVC_NAME {
  default = "claim-che-workspace"
}

variable "CHE_INFRA_KUBERNETES_PVC_STORAGE_CLASS_NAME" {
  default = "claim-che-workspace"
}

