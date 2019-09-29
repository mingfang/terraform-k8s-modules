resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "clusterissuers_certmanager_k8s_io" {
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
    name = "clusterissuers.certmanager.k8s.io"
  }
  spec {
    group = "certmanager.k8s.io"
    names {
      kind   = "ClusterIssuer"
      plural = "clusterissuers"
    }
    scope   = "Cluster"
    version = "v1alpha1"
  }
}