resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-ingressgateway-istio-system" {
  metadata {
    labels = {
      "app"      = "ingressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-ingressgateway-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-ingressgateway-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-ingressgateway-service-account"
    namespace = "${var.namespace}"
  }
}