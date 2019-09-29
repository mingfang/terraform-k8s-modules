resource "k8s_config_istio_io_v1alpha2_handler" "stdio" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "stdio"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "compiledAdapter": "stdio",
      "params": {
        "outputAsJson": true
      }
    }
    JSON
}