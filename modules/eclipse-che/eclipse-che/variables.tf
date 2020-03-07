variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "quay.io/eclipse/che-server:7.9.0"
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

variable data-pvc-name {
  default = "che-data-volume"
  description = "PVC name for Che data"
}

variable "ingress_class" {}

variable CHE_WORKSPACE_DEVFILE__REGISTRY__URL {}

variable CHE_WORKSPACE_PLUGIN__REGISTRY__URL {}

variable CHE_HOST {
  description = "For building the http and websocket URLs"
}


// begin CHE_INFRA_KUBERNETES_SERVER__STRATEGY=multi-host

variable CHE_INFRA_KUBERNETES_SERVER__STRATEGY {
  default = "multi-host"
  description = "default-host, multi-host, single-host"
}

variable CHE_INFRA_KUBERNETES_INGRESS_DOMAIN {
  default = null
  description = "domain suffix for each workspace ingress; Required when CHE_INFRA_KUBERNETES_SERVER__STRATEGY=multi-host"
}

variable CHE_INFRA_KUBERNETES_INGRESS_PATH__TRANSFORM {
  default = null
  description = "set to %s(.*) when CHE_INFRA_KUBERNETES_SERVER__STRATEGY=single-host"
}

variable "CHE_INFRA_KUBERNETES_TLS__ENABLED" {
  default = true
  description = "Will use https and wss URLs if true"
}

variable CHE_INFRA_KUBERNETES_TLS__KEY {
  default = ""
  description = "base64 encoded key coppied to each workspace to enable https for ingress"
}

variable CHE_INFRA_KUBERNETES_TLS__CERT {
  default = ""
  description = "base64 encoded cert coppied to each workspace to enable https for ingress"
}

// end CHE_INFRA_KUBERNETES_SERVER__STRATEGY=multi-host


// begin CHE_MULTIUSER=true

variable CHE_MULTIUSER {
  default = true
  description = "enable multi user support"
}
variable "CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME" {
  default = null
  description = "Extra permissions each workspace will get"
}
variable CHE_INFRA_KUBERNETES_SERVICE__ACCOUNT__NAME {
  default = "che-workspace"
  description = "name of auto created service account for each workspace"
}
variable CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT {
  default = "che-<username>"
  description = "create new namespace for each user"
}

variable CHE_INFRA_KUBERNETES_PVC_NAME {
  default = "claim-che-workspace"
  description = "name of pvc for each workspace"
}
variable "CHE_INFRA_KUBERNETES_PVC_STORAGE__CLASS__NAME" {
  default = "claim-che-workspace"
  description = "storage class for each pvc in each workspace"
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
variable CHE_LIMITS_WORKSPACE_IDLE_TIMEOUT {
  default = 1800000
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

variable CHE_WORKSPACE_SIDECAR_DEFAULT__MEMORY__LIMIT__MB {
  default = 256
}

// set both to "0" if you need root access
variable CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_FS__GROUP {
  default = "1724"
}
variable CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_RUN__AS__USER {
  default = "1724"
}

// end CHE_MULTIUSER=true

variable CHE_SYSTEM_ADMIN__NAME {
  default = "admin"
  description = "Grant system permission for 'che.admin.name' user. If the user already exists it’ll happen oncomponent startup, if not - during the first login when user is persisted in the database."
}
