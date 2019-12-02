variable "name" {}

variable "namespace" {
  default = null
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

