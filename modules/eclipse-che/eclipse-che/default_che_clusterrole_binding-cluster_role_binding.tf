resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding" "default_che_clusterrole_binding" {
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
    name      = "che"
    namespace = var.namespace
  }
}