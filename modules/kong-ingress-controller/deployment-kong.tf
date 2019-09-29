"resource" "k8s_apps_v1_deployment" "kong" {
  "metadata" = [
    {
      "name" = "kong"

      "namespace" = "kong"
    },
  ]

  "spec" = [
    {
      selector {
        match_labels {
          app  = "kong"
          name = "kong"
        }
      }

      "template" = [
        {
          "metadata" = [
            {
              "labels" = {
                "app" = "kong"

                "name" = "kong"
              }
            },
          ]

          "spec" = [
            {
              "containers" = [
                {
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
                      "name" = "KONG_PROXY_ACCESS_LOG"

                      "value" = "/dev/stdout"
                    },
                    {
                      "name" = "KONG_PROXY_ERROR_LOG"

                      "value" = "/dev/stderr"
                    },
                    {
                      "name" = "KONG_ADMIN_LISTEN"

                      "value" = "off"
                    },
                  ]

                  "image" = "kong:0.14.1-centos"

                  "name" = "kong-proxy"

                  "ports" = [
                    {
                      "container_port" = 8000

                      "name" = "proxy"

                      "protocol" = "TCP"
                    },
                    {
                      "container_port" = 8443

                      "name" = "proxy-ssl"

                      "protocol" = "TCP"
                    },
                  ]
                },
              ]

              "init_containers" = [
                {
                  "command" = ["/bin/sh", "-c", "until kong start; do echo 'waiting for db'; sleep 1; done; kong stop"]

                  "env" = [
                    {
                      "name" = "KONG_PROXY_ACCESS_LOG"

                      "value" = "/dev/stdout"
                    },
                    {
                      "name" = "KONG_ADMIN_ACCESS_LOG"

                      "value" = "/dev/stdout"
                    },
                    {
                      "name" = "KONG_PROXY_ERROR_LOG"

                      "value" = "/dev/stderr"
                    },
                    {
                      "name" = "KONG_ADMIN_ERROR_LOG"

                      "value" = "/dev/stderr"
                    },
                    {
                      "name" = "KONG_PG_HOST"

                      "value" = "postgres"
                    },
                    {
                      "name" = "KONG_PG_PASSWORD"

                      "value" = "kong"
                    },
                  ]

                  "image" = "kong:0.14.1-centos"

                  "name" = "wait-for-db"
                },
              ]
            },
          ]
        },
      ]
    },
  ]
}
