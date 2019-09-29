resource "k8s_config_istio_io_v1alpha2_rule" "kubeattrgenrulerule" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kubeattrgenrulerule"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "actions": [
        {
          "handler": "kubernetesenv",
          "instances": [
            "attributes.kubernetes"
          ]
        }
      ]
    }
    JSON
}