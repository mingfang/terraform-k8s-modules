resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-egressgateway-istio-system" {
  metadata {
    labels = {
      "app"      = "egressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-egressgateway-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-egressgateway-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-egressgateway-service-account"
    namespace = "${var.namespace}"
  }
}