"resource" "k8s_batch_v1_job" "kong-migrations" {
  "metadata" = [
    {
      "name" = "kong-migrations"

      "namespace" = "kong"
    },
  ]

  "spec" = [
    {
      "template" = [
        {
          "metadata" = [
            {
              "name" = "kong-migrations"
            },
          ]

          "spec" = [
            {
              "containers" = [
                {
                  "command" = ["/bin/sh", "-c", "kong migrations up"]

                  "env" = [
                    {
                      "name" = "KONG_PG_PASSWORD"

                      "value" = "kong"
                    },
                    {
                      "name" = "KONG_PG_HOST"

                      "value" = "postgres"
                    },
                    {
                      "name" = "KONG_PG_PORT"

                      "value" = "5432"
                    },
                  ]

                  "image" = "kong:0.14.1-centos"

                  "name" = "kong-migrations"
                },
              ]

              "init_containers" = [
                {
                  "command" = ["/bin/sh", "-c", "until nc -zv $KONG_PG_HOST $KONG_PG_PORT -w1; do echo 'waiting for db'; sleep 1; done"]

                  "env" = [
                    {
                      "name" = "KONG_PG_HOST"

                      "value" = "postgres"
                    },
                    {
                      "name" = "KONG_PG_PORT"

                      "value" = "5432"
                    },
                  ]

                  "image" = "busybox"

                  "name" = "wait-for-postgres"
                },
              ]

              "restart_policy" = "OnFailure"
            },
          ]
        },
      ]
    },
  ]
}
