resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "policies_authentication_istio_io" {
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
    name = "policies.authentication.istio.io"
  }
  spec {
    group = "authentication.istio.io"
    names {
      categories = [
        "istio-io",
        "authentication-istio-io",
      ]
      kind     = "Policy"
      plural   = "policies"
      singular = "policy"
    }
    scope   = "Namespaced"
    version = "v1alpha1"
  }
}