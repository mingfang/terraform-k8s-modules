resource "k8s_rbac_authorization_k8s_io_v1_role" "istio-ingressgateway-sds" {
  metadata {
    name      = "istio-ingressgateway-sds"
    namespace = "${var.namespace}"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "secrets",
    ]
    verbs = [
      "get",
      "watch",
      "list",
    ]
  }
}