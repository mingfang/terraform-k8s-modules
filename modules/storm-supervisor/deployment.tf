resource "k8s_apps_v1_deployment" "this" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels = "${local.labels}"
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        containers = [
          {
            name  = "storm"
            image = "${var.image}"

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
            ]

            lifecycle {
              post_start {
                exec {
                  command = [
                    "sh",
                    "-c",
                    "sv start supervisor;",
                  ]
                }
              }
            }

            resources {}

            volume_mounts = [
              {
                mount_path = "/storm/conf/storm.yaml"
                name       = "config"
                sub_path   = "storm.yaml"
              },
            ]
          },
        ]

        security_context {}

        dns_policy                       = "${var.dns_policy}"
        node_selector                    = "${var.node_selector}"
        priority_class_name              = "${var.priority_class_name}"
        restart_policy                   = "${var.restart_policy}"
        scheduler_name                   = "${var.scheduler_name}"
        termination_grace_period_seconds = "${var.termination_grace_period_seconds}"

        volumes = [
          {
            name = "config"

            config_map {
              name = "${k8s_core_v1_config_map.this.metadata.0.name}"
            }
          },
        ]

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["${var.name}"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = ["metadata.0.annotations"]
  }
}
