resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "default_che_clusterrole_binding" {
  metadata {
    name = "${var.namespace}-default-che-clusterrole-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = k8s_core_v1_service_account.che.metadata[0].name
    namespace = var.namespace
  }
}