locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links = false

    containers = [
      {
        name  = "invoker"
        image = var.image
        command = [
          "/bin/bash",
          "-cx",
          "/init.sh --uniqueName $INVOKER_NAME",
        ]
        env = concat([
          {
            name  = "PORT"
            value = "8080"
          },
          {
            name = "WHISK_API_HOST_PROTO"
            value_from = {
              config_map_keyref = {
                key  = "whisk_api_host_proto"
                name = var.whisk_config_name
              }
            }
          },
          {
            name = "WHISK_API_HOST_PORT"
            value_from = {
              config_map_keyref = {
                key  = "whisk_api_host_port"
                name = var.whisk_config_name
              }
            }
          },
          {
            name = "WHISK_API_HOST_NAME"
            value_from = {
              config_map_keyref = {
                key  = "whisk_api_host_name"
                name = var.whisk_config_name
              }
            }
          },
          {
            name  = "CONFIG_whisk_docker_containerFactory_useRunc"
            value = "false"
          },
          {
            name  = "CONFIG_whisk_containerPool_userMemory"
            value = "2048m"
          },
          {
            name  = "CONFIG_whisk_containerFactory_containerArgs_network"
            value = "bridge"
          },
          {
            name  = "CONFIG_whisk_containerFactory_containerArgs_extraEnvVars_0"
            value = "__OW_ALLOW_CONCURRENT=false"
          },
          {
            name  = "CONFIG_whisk_containerFactory_runtimesRegistry_url"
            value = ""
          },
          {
            name = "INVOKER_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "JAVA_OPTS"
            value = "-Xmx512M "
          },
          {
            name  = "INVOKER_OPTS"
            value = " -Dkubernetes.master=https://$KUBERNETES_SERVICE_HOST -Dwhisk.spi.ContainerFactoryProvider=org.apache.openwhisk.core.containerpool.kubernetes.KubernetesContainerFactoryProvider"
          },
          {
            name  = "RUNTIMES_MANIFEST"
            value = <<-EOF
              {
                  "runtimes": {
                      "nodejs": [
                          {
                              "kind": "nodejs:10",
                              "default": true,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-nodejs-v10",
                                  "tag": "1.16.0"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              },
                              "stemCells": [
                                  {
                                      "count": 2,
                                      "memory": "256 MB"
                                  }
                              ]
                          },
                          {
                              "kind": "nodejs:12",
                              "default": false,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-nodejs-v12",
                                  "tag": "1.16.0"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          },
                          {
                              "kind": "nodejs:14",
                              "default": false,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-nodejs-v14",
                                  "tag": "1.16.0"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          }
                      ],
                      "python": [
                          {
                              "kind": "python:2",
                              "default": false,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "python2action",
                                  "tag": "1.13.0-incubating"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          },
                          {
                              "kind": "python:3",
                              "default": true,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "python3action",
                                  "tag": "1.14.0"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          }
                      ],
                      "swift": [
                          {
                              "kind": "swift:4.2",
                              "default": true,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-swift-v4.2",
                                  "tag": "1.14.0"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          },
                          {
                              "kind": "swift:5.1",
                              "default": false,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-swift-v5.1",
                                  "tag": "1.14.0"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          }
                      ],
                      "java": [
                          {
                              "kind": "java:8",
                              "default": true,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "java8action",
                                  "tag": "1.14.0"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "jarfile",
                                  "attachmentType": "application/java-archive"
                              },
                              "requireMain": true
                          }
                      ],
                      "php": [
                          {
                              "kind": "php:7.3",
                              "default": false,
                              "deprecated": false,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-php-v7.3",
                                  "tag": "1.14.0"
                              },
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          },
                          {
                              "kind": "php:7.4",
                              "default": true,
                              "deprecated": false,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-php-v7.4",
                                  "tag": "1.14.0"
                              },
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          }
                      ],
                      "ruby": [
                          {
                              "kind": "ruby:2.5",
                              "default": true,
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              },
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-ruby-v2.5",
                                  "tag": "1.14.0"
                              }
                          }
                      ],
                      "go": [
                          {
                              "kind": "go:1.11",
                              "default": true,
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              },
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-golang-v1.11",
                                  "tag": "1.15.0"
                              }
                          }
                      ],
                      "rust": [
                          {
                              "kind": "rust:1.34",
                              "default": true,
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              },
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-rust-v1.34",
                                  "tag": "1.0.0"
                              }
                          }
                      ],
                      "dotnet": [
                          {
                              "kind": "dotnet:2.2",
                              "default": true,
                              "deprecated": false,
                              "requireMain": true,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-dotnet-v2.2",
                                  "tag": "1.15.0"
                              },
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          },
                          {
                              "kind": "dotnet:3.1",
                              "default": false,
                              "deprecated": false,
                              "requireMain": true,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-dotnet-v3.1",
                                  "tag": "1.15.0"
                              },
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          }
                      ],
                      "ballerina": [
                          {
                              "kind": "ballerina:0.990",
                              "default": true,
                              "image": {
                                  "prefix": "openwhisk",
                                  "name": "action-ballerina-v0.990.2",
                                  "tag": "nightly"
                              },
                              "deprecated": false,
                              "attached": {
                                  "attachmentName": "codefile",
                                  "attachmentType": "text/plain"
                              }
                          }
                      ]
                  },
                  "blackboxes": [
                      {
                          "prefix": "openwhisk",
                          "name": "dockerskeleton",
                          "tag": "1.14.0"
                      }
                  ]
              }
              EOF
          },
          {
            name  = "LIMITS_ACTIONS_INVOKES_PERMINUTE"
            value = "60"
          },
          {
            name  = "LIMITS_ACTIONS_INVOKES_CONCURRENT"
            value = "30"
          },
          {
            name  = "LIMITS_TRIGGERS_FIRES_PERMINUTE"
            value = "60"
          },
          {
            name  = "LIMITS_ACTIONS_SEQUENCE_MAXLENGTH"
            value = "50"
          },
          {
            name  = "CONFIG_whisk_timeLimit_min"
            value = "100ms"
          },
          {
            name  = "CONFIG_whisk_timeLimit_max"
            value = "5m"
          },
          {
            name  = "CONFIG_whisk_timeLimit_std"
            value = "1m"
          },
          {
            name  = "CONFIG_whisk_memory_min"
            value = "128m"
          },
          {
            name  = "CONFIG_whisk_memory_max"
            value = "512m"
          },
          {
            name  = "CONFIG_whisk_memory_std"
            value = "256m"
          },
          {
            name  = "CONFIG_whisk_concurrencyLimit_min"
            value = "1"
          },
          {
            name  = "CONFIG_whisk_concurrencyLimit_max"
            value = "1"
          },
          {
            name  = "CONFIG_whisk_concurrencyLimit_std"
            value = "1"
          },
          {
            name  = "CONFIG_whisk_logLimit_min"
            value = "0m"
          },
          {
            name  = "CONFIG_whisk_logLimit_max"
            value = "10m"
          },
          {
            name  = "CONFIG_whisk_logLimit_std"
            value = "10m"
          },
          {
            name  = "CONFIG_whisk_activation_payload_max"
            value = "1048576"
          },
          {
            name  = "WHISK_LOGS_DIR"
            value = ""
          },
          {
            name = "CONFIG_whisk_info_date"
            value_from = {
              config_map_keyref = {
                key  = "whisk_info_date"
                name = var.whisk_config_name
              }
            }
          },
          {
            name = "CONFIG_whisk_couchdb_username"
            value_from = {
              secret_key_ref = {
                key  = "db_username"
                name = var.db_secret_name
              }
            }
          },
          {
            name = "CONFIG_whisk_couchdb_password"
            value_from = {
              secret_key_ref = {
                key  = "db_password"
                name = var.db_secret_name
              }
            }
          },
          {
            name = "CONFIG_whisk_couchdb_port"
            value_from = {
              config_map_keyref = {
                key  = "db_port"
                name = var.db_config_name
              },
            },
          },
          {
            name = "CONFIG_whisk_couchdb_protocol"
            value_from = {
              config_map_keyref = {
                key  = "db_protocol"
                name = var.db_config_name
              }
            }
          },
          {
            name  = "CONFIG_whisk_couchdb_host"
            value_from = {
              config_map_keyref = {
                key  = "db_host"
                name = var.db_config_name
              }
            }
          },
          {
            name = "CONFIG_whisk_couchdb_provider"
            value_from = {
              config_map_keyref = {
                key  = "db_provider"
                name = var.db_config_name
              }
            }
          },
          {
            name = "CONFIG_whisk_couchdb_databases_WhiskActivation"
            value_from = {
              config_map_keyref = {
                key  = "db_whisk_activations"
                name = var.db_config_name
              }
            }
          },
          {
            name = "CONFIG_whisk_couchdb_databases_WhiskEntity"
            value_from = {
              config_map_keyref = {
                key  = "db_whisk_actions"
                name = var.db_config_name
              }
            }
          },
          {
            name = "CONFIG_whisk_couchdb_databases_WhiskAuth"
            value_from = {
              config_map_keyref = {
                key  = "db_whisk_auths"
                name = var.db_config_name
              }
            }
          },
          {
            name  = "KAFKA_HOSTS"
            value = var.KAFKA_HOSTS
          },
          {
            name  = "CONFIG_whisk_kafka_replicationFactor"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_cacheInvalidation_retentionBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_cacheInvalidation_retentionMs"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_cacheInvalidation_segmentBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_completed_retentionBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_completed_retentionMs"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_completed_segmentBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_events_retentionBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_events_retentionMs"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_events_segmentBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_health_retentionBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_health_retentionMs"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_health_segmentBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_invoker_retentionBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_invoker_retentionMs"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kafka_topics_invoker_segmentBytes"
            value = ""
          },
          {
            name  = "CONFIG_whisk_kubernetes_userPodNodeAffinity_enabled"
            value = false
          },
          {
            name  = "ZOOKEEPER_HOSTS"
            value = var.ZOOKEEPER_HOSTS
          },
          {
            name  = "CONFIG_logback_log_level"
            value = "INFO"
          },
        ], var.env)
      },
    ]
    service_account_name = module.rbac.name
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
