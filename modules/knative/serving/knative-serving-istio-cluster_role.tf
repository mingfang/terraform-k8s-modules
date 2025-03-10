resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "knative-serving-istio" {
  metadata {
    labels = {
      "networking.knative.dev/ingress-provider" = "istio"
      "serving.knative.dev/controller"          = "true"
      "serving.knative.dev/release"             = "devel"
    }
    name = "knative-serving-istio"
  }

  rules {
    api_groups = [
      "networking.istio.io",
    ]
    resources = [
      "virtualservices",
      "gateways",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
}