"resource" "k8s_apps_v1_stateful_set" "postgres" {
  "metadata" = [
    {
      "name" = "postgres"

      "namespace" = "kong"
    },
  ]

  "spec" = [
    {
      "replicas" = 1

      "selector" = [
        {
          "match_labels" = {
            "app" = "postgres"
          }
        },
      ]

      "service_name" = "postgres"

      "template" = [
        {
          "metadata" = [
            {
              "labels" = {
                "app" = "postgres"
              }
            },
          ]

          "spec" = [
            {
              "containers" = [
                {
                  "env" = [
                    {
                      "name" = "POSTGRES_USER"

                      "value" = "kong"
                    },
                    {
                      "name" = "POSTGRES_PASSWORD"

                      "value" = "kong"
                    },
                    {
                      "name" = "POSTGRES_DB"

                      "value" = "kong"
                    },
                    {
                      "name" = "PGDATA"

                      "value" = "/var/lib/postgresql/data/pgdata"
                    },
                  ]

                  "image" = "postgres:9.5"

                  "name" = "postgres"

                  "ports" = [
                    {
                      "container_port" = 5432
                    },
                  ]

                  "volume_mounts" = [
                    {
                      "mount_path" = "/var/lib/postgresql/data"

                      "name" = "datadir"

                      "sub_path" = "pgdata"
                    },
                  ]
                },
              ]

              "termination_grace_period_seconds" = 60
            },
          ]
        },
      ]

      "volume_claim_templates" = [
        {
          "metadata" = [
            {
              "name" = "datadir"
            },
          ]

          "spec" = [
            {
              "access_modes" = ["ReadWriteOnce"]

              "resources" = [
                {
                  "requests" = {
                    "storage" = "1Gi"
                  }
                },
              ]
            },
          ]
        },
      ]
    },
  ]
}
