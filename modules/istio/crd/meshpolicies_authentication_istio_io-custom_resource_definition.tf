resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "meshpolicies_authentication_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-citadel"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "meshpolicies.authentication.istio.io"
  }
  spec {
    group = "authentication.istio.io"
    names {
      categories = [
        "istio-io",
        "authentication-istio-io",
      ]
      kind      = "MeshPolicy"
      list_kind = "MeshPolicyList"
      plural    = "meshpolicies"
      singular  = "meshpolicy"
    }
    scope   = "Cluster"
    version = "v1alpha1"
  }
}