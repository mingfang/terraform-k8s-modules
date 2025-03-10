resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "keda_operator" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-operator"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "keda-operator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "keda-operator"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "keda-operator"
    namespace = k8s_core_v1_namespace.keda.metadata.0.name
  }
}