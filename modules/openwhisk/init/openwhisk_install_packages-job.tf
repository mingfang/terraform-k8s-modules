resource "k8s_batch_v1_job" "openwhisk_install_packages" {
  metadata {
    labels = {
      "app"      = "openwhisk-openwhisk"
      "chart"    = "openwhisk-0.2.5"
      "heritage" = "Helm"
      "name"     = "openwhisk-install-packages"
      "release"  = "openwhisk"
    }
    name = "openwhisk-install-packages"
    namespace = var.namespace
  }
  spec {
    backoff_limit = 3
    template {
      metadata {
        labels = {
          "app"      = "openwhisk-openwhisk"
          "chart"    = "openwhisk-0.2.5"
          "heritage" = "Helm"
          "name"     = "openwhisk-install-packages"
          "release"  = "openwhisk"
        }
        name = "openwhisk-install-packages"
      }
      spec {

        containers {
          command = [
            "/bin/bash",
            "-c",
            "set -e; . /task/myTask.sh",
          ]

          env {
            name = "WHISK_AUTH"
            value_from {
              secret_key_ref {
                key  = "system"
                name = var.whisk_secret_name
              }
            }
          }
          env {
            name = "WHISK_API_HOST"
            value_from {
              config_map_keyref {
                key  = "whisk_api_host_nameAndPort"
                name = var.whisk_config_name
              }
            }
          }
          env {
            name = "WHISK_API_HOST_URL"
            value_from {
              config_map_keyref {
                key  = "whisk_api_host_url"
                name = var.whisk_config_name
              }
            }
          }
          env {
            name = "WHISK_SYSTEM_NAMESPACE"
            value_from {
              config_map_keyref {
                key  = "whisk_system_namespace"
                name = var.whisk_config_name
              }
            }
          }
          env {
            name  = "WHISK_API_GATEWAY_HOST_V2"
            value = var.WHISK_API_GATEWAY_HOST_V2
          }
          env {
            name = "PROVIDER_DB_HOST"
            value_from {
              config_map_keyref {
                key  = "db_host"
                name = var.db_config_name
              }
            }
          }
          env {
            name = "PROVIDER_DB_PROTOCOL"
            value_from {
              config_map_keyref {
                key  = "db_protocol"
                name = var.db_config_name
              }
            }
          }
          env {
            name = "PROVIDER_DB_PORT"
            value_from {
              config_map_keyref {
                key  = "db_port"
                name = var.db_config_name
              }
            }
          }
          env {
            name = "PROVIDER_DB_USERNAME"
            value_from {
              secret_key_ref {
                key  = "db_username"
                name = var.db_secret_name
              }
            }
          }
          env {
            name = "PROVIDER_DB_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "db_password"
                name = var.db_secret_name
              }
            }
          }
          env {
            name  = "ALARM_DB_PREFIX"
            value = "alm"
          }
          env {
            name  = "KAFKA_DB_PREFIX"
            value = "kp"
          }
          env {
            name  = "OW_INSTALL_ALARM_PROVIDER"
            value = "yes"
          }
          env {
            name  = "OW_INSTALL_KAFKA_PROVIDER"
            value = "yes"
          }
          env {
            name  = "OW_GIT_TAG_OPENWHISK"
            value = "71b7d564ff60bf6e89be5410ffcf59f785d17a4a"
          }
          env {
            name  = "OW_GIT_TAG_OPENWHISK_CATALOG"
            value = "0.11.0"
          }
          env {
            name  = "OW_GIT_TAG_OPENWHISK_PACKAGE_ALARMS"
            value = "2.2.0"
          }
          env {
            name  = "OW_GIT_TAG_OPENWHISK_PACKAGE_KAFKA"
            value = "2.1.0"
          }
          image             = "openwhisk/ow-utils:71b7d56"
          image_pull_policy = "IfNotPresent"
          name              = "install-packages"

          volume_mounts {
            mount_path = "/task/myTask.sh"
            name       = "task-dir"
            sub_path   = "myTask.sh"
          }
        }

/*
        init_containers {
          command = [
            "sh",
            "-c",
            <<-EOF
            echo 0 > /tmp/count.txt; while true; do echo 'waiting for healthy invoker'; wget -T 5 -qO /tmp/count.txt --no-check-certificate "$READINESS_URL"; NUM_HEALTHY_INVOKERS=$(cat /tmp/count.txt); if [ $NUM_HEALTHY_INVOKERS -gt 0 ]; then echo "Success: there are $NUM_HEALTHY_INVOKERS healthy invokers"; break; fi; echo '...not ready yet; sleeping 3 seconds before retry'; sleep 3; done;
            EOF
            ,
          ]

          env {
            name  = "READINESS_URL"
            value = "http://openwhisk-controller.default.svc.cluster.local:8080/invokers/healthy/count"
          }
          image             = "busybox"
          image_pull_policy = "IfNotPresent"
          name              = "wait-for-healthy-invoker"
        }
*/
        restart_policy = "Never"

        volumes {
          config_map {
            name = "openwhisk-install-packages-cm"
          }
          name = "task-dir"
        }
      }
    }
  }
}