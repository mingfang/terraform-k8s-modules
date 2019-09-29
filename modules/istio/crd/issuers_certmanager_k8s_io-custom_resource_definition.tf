resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "issuers_certmanager_k8s_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "certmanager"
      "chart"    = "certmanager"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "issuers.certmanager.k8s.io"
  }
  spec {
    group = "certmanager.k8s.io"
    names {
      kind   = "Issuer"
      plural = "issuers"
    }
    scope   = "Namespaced"
    version = "v1alpha1"
  }
}