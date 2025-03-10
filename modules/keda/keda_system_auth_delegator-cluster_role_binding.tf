resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "keda_system_auth_delegator" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-system-auth-delegator"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "keda-system-auth-delegator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "keda-operator"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
  }
}