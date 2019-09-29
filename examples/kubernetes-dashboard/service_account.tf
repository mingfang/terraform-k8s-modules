/*
Service Account to login to dashboard
*/

resource "k8s_core_v1_service_account" "cluster-admin" {
  metadata {
    name      = "cluster-admin"
    namespace = "kube-system"
  }
}

resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "cluster-admin" {
  metadata {
    name = "cluster-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subjects {
    kind      = "ServiceAccount"
    name      = k8s_core_v1_service_account.cluster-admin.metadata[0].name
    namespace = k8s_core_v1_service_account.cluster-admin.metadata[0].namespace
  }
}

/*
data "k8s_core_v1_secret" "cluster-admin" {
  count = k8s_core_v1_service_account.cluster-admin.secrets[0].name == null ? 0 : 1
  metadata {
    name        = k8s_core_v1_service_account.cluster-admin.secrets[0].name
    namespace   = k8s_core_v1_service_account.cluster-admin.metadata[0].namespace
  }
}

output "cluster-admin_token" {
  value = base64decode(data.k8s_core_v1_secret.cluster-admin[0].data.token)
}
*/
