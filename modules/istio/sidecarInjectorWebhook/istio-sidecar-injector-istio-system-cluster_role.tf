resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio-sidecar-injector-istio-system" {
  metadata {
    labels = {
      "app"      = "sidecarInjectorWebhook"
      "chart"    = "sidecarInjectorWebhook"
      "heritage" = "Tiller"
      "istio"    = "sidecar-injector"
      "release"  = "istio"
    }
    name = "istio-sidecar-injector-istio-system"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "admissionregistration.k8s.io",
    ]
    resources = [
      "mutatingwebhookconfigurations",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "patch",
    ]
  }
}