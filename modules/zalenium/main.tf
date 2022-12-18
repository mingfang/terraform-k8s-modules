locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links = false
    service_account_name = module.rbac.service_account.metadata[0].name

    containers = [
      {
        name  = "zalenium"
        image = var.image
        args  = ["start"]

        env = concat([
          {
            name  = "ZALENIUM_KUBERNETES_CPU_REQUEST"
            value = var.ZALENIUM_KUBERNETES_CPU_REQUEST
          },
          {
            name  = "ZALENIUM_KUBERNETES_CPU_LIMIT"
            value = var.ZALENIUM_KUBERNETES_CPU_LIMIT
          },
          {
            name  = "ZALENIUM_KUBERNETES_MEMORY_REQUEST"
            value = var.ZALENIUM_KUBERNETES_MEMORY_REQUEST
          },
          {
            name  = "ZALENIUM_KUBERNETES_MEMORY_LIMIT"
            value = var.ZALENIUM_KUBERNETES_MEMORY_LIMIT
          },
          {
            name  = "DESIRED_CONTAINERS"
            value = var.DESIRED_CONTAINERS
          },
          {
            name  = "MAX_DOCKER_SELENIUM_CONTAINERS"
            value = var.MAX_DOCKER_SELENIUM_CONTAINERS
          },
          {
            name  = "SELENIUM_IMAGE_NAME"
            value = var.SELENIUM_IMAGE_NAME
          },
          {
            name  = "VIDEO_RECORDING_ENABLED"
            value = var.VIDEO_RECORDING_ENABLED
          },
          {
            name  = "SCREEN_WIDTH"
            value = var.SCREEN_WIDTH
          },
          {
            name  = "SCREEN_HEIGHT"
            value = var.SCREEN_HEIGHT
          },
          {
            name  = "MAX_TEST_SESSIONS"
            value = var.MAX_TEST_SESSIONS
          },
          {
            name  = "NEW_SESSION_WAIT_TIMEOUT"
            value = var.NEW_SESSION_WAIT_TIMEOUT
          },
          {
            name  = "DEBUG_ENABLED"
            value = var.DEBUG_ENABLED
          },
          {
            name  = "SEND_ANONYMOUS_USAGE_INFO"
            value = var.SEND_ANONYMOUS_USAGE_INFO
          },
          {
            name  = "TZ"
            value = var.TZ
          },
          {
            name  = "KEEP_ONLY_FAILED_TESTS"
            value = var.KEEP_ONLY_FAILED_TESTS
          },
          {
            name  = "RETENTION_PERIOD"
            value = var.RETENTION_PERIOD
          },
          {
            name  = "CONTEXT_PATH"
            value = var.CONTEXT_PATH
          },
          {
            name  = "NGINX_MAX_BODY_SIZE"
            value = var.NGINX_MAX_BODY_SIZE
          },
          {
            name  = "TIME_TO_WAIT_TO_START"
            value = var.TIME_TO_WAIT_TO_START
          },
          ],
          var.user_secret_name != null ? [
            {
              name = "GRID_USER"
              value_from = {
                secret_key_ref = {
                  name = var.user_secret_name
                  key  = "GRID_USER"
                }
              }
            },
            {
              name = "GRID_PASSWORD"
              value_from = {
                secret_key_ref = {
                  name = var.user_secret_name
                  key  = "GRID_PASSWORD"
                }
              }
            },
          ] : [],
          var.ZALENIUM_KUBERNETES_NODE_SELECTOR != null ? [{
            name  = "ZALENIUM_KUBERNETES_NODE_SELECTOR"
            value = var.ZALENIUM_KUBERNETES_NODE_SELECTOR
          }] : [],
          var.ZALENIUM_KUBERNETES_TOLERATIONS != null ? [{
            name  = "ZALENIUM_KUBERNETES_TOLERATIONS"
            value = var.ZALENIUM_KUBERNETES_TOLERATIONS
          }] : [],
        var.env)

        volume_mounts = var.pvc_name != null ? [
          {
            name       = "videos"
            mount_path = "/home/seluser/videos"
          },
        ] : []

      }
    ]

    affinity = {
      pod_anti_affinity = {
        required_during_scheduling_ignored_during_execution = [
          {
            label_selector = {
              match_expressions = [
                {
                  key      = "name"
                  operator = "In"
                  values   = [var.name]
                }
              ]
            }
            topology_key = "kubernetes.io/hostname"
          }
        ]
      }
    }

    volumes = var.pvc_name != null ? [
      {
        name = "videos"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
      }
    ] : []
  }
}

module "rbac" {
  source    = "../kubernetes/rbac"
  name      = var.name
  namespace = var.namespace
  role_rules = [
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods",
      ]
      verbs = [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods/exec",
      ]
      verbs = [
        "create",
        "get",
      ]
    },
  ]
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
