resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "metallb-system_speaker" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name = "metallb-system:speaker"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "metallb-system:speaker"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "speaker"
    namespace = k8s_core_v1_service_account.speaker.metadata.0.namespace
  }
}