resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-sidecar-injector-admin-role-binding-istio-system" {
  metadata {
    labels = {
      "app"      = "sidecarInjectorWebhook"
      "chart"    = "sidecarInjectorWebhook"
      "heritage" = "Tiller"
      "istio"    = "sidecar-injector"
      "release"  = "istio"
    }
    name = "istio-sidecar-injector-admin-role-binding-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-sidecar-injector-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-sidecar-injector-service-account"
    namespace = "${var.namespace}"
  }
}