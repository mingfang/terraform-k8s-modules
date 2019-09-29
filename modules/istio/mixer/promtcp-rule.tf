resource "k8s_config_istio_io_v1alpha2_rule" "promtcp" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "promtcp"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "actions": [
        {
          "handler": "prometheus",
          "instances": [
            "tcpbytesent.metric",
            "tcpbytereceived.metric"
          ]
        }
      ],
      "match": "context.protocol == \"tcp\""
    }
    JSON
}