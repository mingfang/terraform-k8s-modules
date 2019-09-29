resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "rbacconfigs_rbac_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "rbac"
      "package"  = "istio.io.mixer"
      "release"  = "istio"
    }
    name = "rbacconfigs.rbac.istio.io"
  }
  spec {
    group = "rbac.istio.io"
    names {
      categories = [
        "istio-io",
        "rbac-istio-io",
      ]
      kind     = "RbacConfig"
      plural   = "rbacconfigs"
      singular = "rbacconfig"
    }
    scope   = "Namespaced"
    version = "v1alpha1"
  }
}