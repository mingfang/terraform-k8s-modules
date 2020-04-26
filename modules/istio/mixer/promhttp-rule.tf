resource "k8s_config_istio_io_v1alpha2_rule" "promhttp" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "promhttp"
    namespace = var.namespace
  }
  spec = <<-JSON
    {
      "actions": [
        {
          "handler": "prometheus",
          "instances": [
            "requestcount",
            "requestduration",
            "requestsize",
            "responsesize"
          ]
        }
      ],
      "match": "(context.protocol == \"http\" || context.protocol == \"grpc\") \u0026\u0026 (match((request.useragent | \"-\"), \"kube-probe*\") == false) \u0026\u0026 (match((request.useragent | \"-\"), \"Prometheus*\") == false)"
    }
    JSON
}