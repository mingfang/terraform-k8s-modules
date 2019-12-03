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

variable CHE_LIMITS_USER_WORKSPACES_RUN_COUNT {
  default = 10
}

variable CHE_KEYCLOAK_AUTH__SERVER__URL {
  default = ""
}
variable CHE_KEYCLOAK_CLIENT__ID {
  default = ""
}
variable CHE_KEYCLOAK_REALM {
  default = ""
}
variable CHE_MULTIUSER {
  default = false
}

variable CHE_WORKSPACE_DEVFILE__REGISTRY__URL {}
variable CHE_WORKSPACE_PLUGIN__REGISTRY__URL {}

variable "CHE_INFRA_KUBERNETES_TLS__ENABLED" {
  default = true
}
variable CHE_HOST {}

