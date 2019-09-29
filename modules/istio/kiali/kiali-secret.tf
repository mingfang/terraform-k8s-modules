resource "k8s_core_v1_secret" "kiali" {
  data = {
    "passphrase" = "YWRtaW4="
    "username"   = "YWRtaW4="
  }
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kiali"
    namespace = "${var.namespace}"
  }
  type = "Opaque"
}