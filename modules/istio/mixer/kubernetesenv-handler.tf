resource "k8s_config_istio_io_v1alpha2_handler" "kubernetesenv" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kubernetesenv"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "compiledAdapter": "kubernetesenv",
      "params": null
    }
    JSON
}