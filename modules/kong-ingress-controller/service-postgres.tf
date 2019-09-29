"resource" "k8s_core_v1_service" "postgres" {
  "metadata" = [
    {
      "name" = "postgres"

      "namespace" = "kong"
    },
  ]

  "spec" = [
    {
      "ports" = [
        {
          "name" = "pgql"

          "port" = 5432

          "protocol" = "TCP"

          "target_port" = 5432
        },
      ]

      "selector" = {
        "app" = "postgres"
      }
    },
  ]
}
