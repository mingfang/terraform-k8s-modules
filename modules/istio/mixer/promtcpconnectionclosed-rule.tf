resource "k8s_config_istio_io_v1alpha2_rule" "promtcpconnectionclosed" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "promtcpconnectionclosed"
    namespace = var.namespace
  }
  spec = <<-JSON
    {
      "actions": [
        {
          "handler": "prometheus",
          "instances": [
            "tcpconnectionsclosed"
          ]
        }
      ],
      "match": "context.protocol == \"tcp\" \u0026\u0026 ((connection.event | \"na\") == \"close\")"
    }
    JSON
}