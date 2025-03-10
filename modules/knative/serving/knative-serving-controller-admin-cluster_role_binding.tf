resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "knative-serving-controller-admin" {
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name = "knative-serving-controller-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "knative-serving-admin"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "controller"
    namespace = "${var.namespace}"
  }
}