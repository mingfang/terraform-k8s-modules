"resource" "k8s_apps_v1_deployment" "kong-ingress-controller" {
  "metadata" = [
    {
      "labels" = {
        "app" = "ingress-kong"
      }

      "name" = "kong-ingress-controller"

      "namespace" = "kong"
    },
  ]

  "spec" = [
    {
      "selector" = [
        {
          "match_labels" = {
            "app" = "ingress-kong"
          }
        },
      ]

      "strategy" = [
        {
          "rolling_update" = [
            {
              "max_surge" = 1

              "max_unavailable" = 0
            },
          ]

          "type" = "RollingUpdate"
        },
      ]

      "template" = [
        {
          "metadata" = [
            {
              "annotations" = {
                "prometheus.io/port" = "10254"

                "prometheus.io/scrape" = "true"
              }

              "labels" = {
                "app" = "ingress-kong"
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
                      "name" = "KONG_ADMIN_ACCESS_LOG"

                      "value" = "/dev/stdout"
                    },
                    {
                      "name" = "KONG_ADMIN_ERROR_LOG"

                      "value" = "/dev/stderr"
                    },
                    {
                      "name" = "KONG_ADMIN_LISTEN"

                      "value" = "0.0.0.0:8001"
                    },
                    {
                      "name" = "KONG_PROXY_LISTEN"

                      "value" = "off"
                    },
                  ]

                  "image" = "kong:0.14.1-centos"

                  "liveness_probe" = [
                    {
                      "failure_threshold" = 3

                      "http_get" = [
                        {
                          "path" = "/status"

                          "port" = 8001

                          "scheme" = "HTTP"
                        },
                      ]

                      "initial_delay_seconds" = 30

                      "period_seconds" = 10

                      "success_threshold" = 1

                      "timeout_seconds" = 1
                    },
                  ]

                  "name" = "admin-api"

                  "ports" = [
                    {
                      "container_port" = 8001

                      "name" = "kong-admin"
                    },
                  ]

                  "readiness_probe" = [
                    {
                      "failure_threshold" = 3

                      "http_get" = [
                        {
                          "path" = "/status"

                          "port" = 8001

                          "scheme" = "HTTP"
                        },
                      ]

                      "period_seconds" = 10

                      "success_threshold" = 1

                      "timeout_seconds" = 1
                    },
                  ]
                },
                {
                  "args" = ["/kong-ingress-controller", "--kong-url=http://localhost:8001", "--default-backend-service=kong/kong-proxy", "--publish-service=kong/kong-proxy"]

                  "env" = [
                    {
                      "name" = "POD_NAME"

                      "value_from" = [
                        {
                          "field_ref" = [
                            {
                              "api_version" = "v1"

                              "field_path" = "metadata.name"
                            },
                          ]
                        },
                      ]
                    },
                    {
                      "name" = "POD_NAMESPACE"

                      "value_from" = [
                        {
                          "field_ref" = [
                            {
                              "api_version" = "v1"

                              "field_path" = "metadata.namespace"
                            },
                          ]
                        },
                      ]
                    },
                  ]

                  "image" = "kong-docker-kubernetes-ingress-controller.bintray.io/kong-ingress-controller:0.2.0"

                  "image_pull_policy" = "IfNotPresent"

                  "liveness_probe" = [
                    {
                      "failure_threshold" = 3

                      "http_get" = [
                        {
                          "path" = "/healthz"

                          "port" = 10254

                          "scheme" = "HTTP"
                        },
                      ]

                      "initial_delay_seconds" = 30

                      "period_seconds" = 10

                      "success_threshold" = 1

                      "timeout_seconds" = 1
                    },
                  ]

                  "name" = "ingress-controller"

                  "readiness_probe" = [
                    {
                      "failure_threshold" = 3

                      "http_get" = [
                        {
                          "path" = "/healthz"

                          "port" = 10254

                          "scheme" = "HTTP"
                        },
                      ]

                      "period_seconds" = 10

                      "success_threshold" = 1

                      "timeout_seconds" = 1
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

              "service_account_name" = "kong-serviceaccount"
            },
          ]
        },
      ]
    },
  ]
}
