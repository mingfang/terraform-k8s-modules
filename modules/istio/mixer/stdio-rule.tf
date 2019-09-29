resource "k8s_config_istio_io_v1alpha2_rule" "stdio" {
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
      "actions": [
        {
          "handler": "stdio",
          "instances": [
            "accesslog.logentry"
          ]
        }
      ],
      "match": "context.protocol == \"http\" || context.protocol == \"grpc\""
    }
    JSON
}