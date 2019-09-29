resource "k8s_config_istio_io_v1alpha2_rule" "promtcpconnectionclosed" {
  metadata {
    name      = "promtcpconnectionclosed"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "actions": [
        {
          "handler": "prometheus",
          "instances": [
            "tcpconnectionsclosed.metric"
          ]
        }
      ],
      "match": "context.protocol == \"tcp\" \u0026\u0026 ((connection.event | \"na\") == \"close\")"
    }
    JSON
}