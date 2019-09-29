resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio-ingressgateway-istio-system" {
  metadata {
    labels = {
      "app"      = "ingressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-ingressgateway-istio-system"
  }

  rules {
    api_groups = [
      "networking.istio.io",
    ]
    resources = [
      "virtualservices",
      "destinationrules",
      "gateways",
    ]
    verbs = [
      "get",
      "watch",
      "list",
      "update",
    ]
  }
}