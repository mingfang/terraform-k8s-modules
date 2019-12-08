variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "eclipse/che-server:7.5.1"
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

// domain for multi-host
variable CHE_INFRA_KUBERNETES_INGRESS_DOMAIN {
  default = null
}

// default to single-host
variable CHE_INFRA_KUBERNETES_SERVER__STRATEGY {
  default = "single-host"
}

// Extra permissions each workspace will get
variable "CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME" {
  default = null
}

// name of auto created service account for each workspace
variable CHE_INFRA_KUBERNETES_SERVICE__ACCOUNT__NAME {
  default = "che-workspace"
}

// create new namespace for each user
variable CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT {
  default = "che-<username>"
}

// name of pvc for each workspace
variable CHE_INFRA_KUBERNETES_PVC_NAME {
  default = "claim-che-workspace"
}

// storage class for each pvc in each workspace
variable "CHE_INFRA_KUBERNETES_PVC_STORAGE__CLASS__NAME" {
  default = "claim-che-workspace"
}
variable CHE_INFRA_KUBERNETES_PVC_QUANTITY {
  default = "10Gi"
}
variable CHE_INFRA_KUBERNETES_PVC_ACCESS__MODE {
  default = "ReadWriteOnce"
}


// limit number of active workspaces for each user
variable CHE_LIMITS_USER_WORKSPACES_RUN_COUNT {
  default = 10
}

// keycloak integration
variable CHE_KEYCLOAK_AUTH__SERVER__URL {
  default = ""
}
variable CHE_KEYCLOAK_CLIENT__ID {
  default = ""
}
variable CHE_KEYCLOAK_REALM {
  default = ""
}

// enable multi user support
variable CHE_MULTIUSER {
  default = false
}

variable CHE_WORKSPACE_DEVFILE__REGISTRY__URL {}
variable CHE_WORKSPACE_PLUGIN__REGISTRY__URL {}

variable CHE_WORKSPACE_SIDECAR_DEFAULT__MEMORY__LIMIT__MB {
  default = 256
}

// enable https
variable "CHE_INFRA_KUBERNETES_TLS__ENABLED" {
  default = true
}
variable CHE_HOST {}

