resource "k8s_batch_v1_job" "openwhisk_init_couchdb" {
  metadata {
    labels = {
      "app"      = "openwhisk-openwhisk"
      "chart"    = "openwhisk-0.2.5"
      "heritage" = "Helm"
      "name"     = "openwhisk-init-couchdb"
      "release"  = "openwhisk"
    }
    name = "openwhisk-init-couchdb"
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
          "name"     = "openwhisk-init-couchdb"
          "release"  = "openwhisk"
        }
        name = "openwhisk-init-couchdb"
      }
      spec {

        containers {
          command = [
            "/bin/bash",
            "-c",
            "set -e; . /task/initdb.sh",
          ]

          env {
            name = "DB_PROTOCOL"
            value_from {
              config_map_keyref {
                key  = "db_protocol"
                name = var.db_config_name
              }
            }
          }
          env {
            name = "DB_HOST"
            value_from {
              config_map_keyref {
                key  = "db_host"
                name = var.db_config_name
              }
            }
          }
          env {
            name = "DB_PORT"
            value_from {
              config_map_keyref {
                key  = "db_port"
                name = var.db_config_name
              }
            }
          }
          env {
            name = "DB_PREFIX"
            value_from {
              config_map_keyref {
                key  = "db_prefix"
                name = var.db_config_name
              }
            }
          }
          env {
            name = "COUCHDB_USER"
            value_from {
              secret_key_ref {
                key  = "db_username"
                name = var.db_secret_name
              }
            }
          }
          env {
            name = "COUCHDB_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "db_password"
                name = var.db_secret_name
              }
            }
          }
          env {
            name  = "NODENAME"
            value = "couchdb0"
          }
          env {
            name  = "OW_GIT_TAG_OPENWHISK"
            value = "71b7d564ff60bf6e89be5410ffcf59f785d17a4a"
          }
          image             = "openwhisk/ow-utils:71b7d56"
          image_pull_policy = "IfNotPresent"
          name              = "init-couchdb"

          volume_mounts {
            mount_path = "/task/initdb.sh"
            name       = "task-dir"
            sub_path   = "initdb.sh"
          }
          volume_mounts {
            mount_path = "/etc/whisk-auth"
            name       = "whisk-auth"
          }
        }
        restart_policy = "Never"

        volumes {
          config_map {
            name = "openwhisk-init-couchdb"
          }
          name = "task-dir"
        }
        volumes {
          name = "whisk-auth"
          secret {
            secret_name = "openwhisk-whisk.auth"
          }
        }
      }
    }
  }
}