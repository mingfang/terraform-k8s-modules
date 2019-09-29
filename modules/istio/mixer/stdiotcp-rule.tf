resource "k8s_config_istio_io_v1alpha2_rule" "stdiotcp" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "stdiotcp"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "actions": [
        {
          "handler": "stdio",
          "instances": [
            "tcpaccesslog.logentry"
          ]
        }
      ],
      "match": "context.protocol == \"tcp\""
    }
    JSON
}