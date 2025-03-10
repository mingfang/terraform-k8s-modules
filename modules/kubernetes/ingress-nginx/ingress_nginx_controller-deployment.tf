resource "k8s_apps_v1_deployment" "nginx_ingress_controller" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        "app.kubernetes.io/name"    = var.name
        "app.kubernetes.io/part-of" = var.name
      }
    }
    template {
      metadata {
        annotations = {
          "prometheus.io/port"   = "10254"
          "prometheus.io/scrape" = "true"
        }
        labels = {
          "app.kubernetes.io/name"    = var.name
          "app.kubernetes.io/part-of" = var.name
        }
      }
      spec {

        containers {
          args = concat(
            [
              "/nginx-ingress-controller",
              "--election-id=${var.name}",
              "--ingress-class=${var.ingress_class}",
              "--configmap=$(POD_NAMESPACE)/${var.name}-nginx-configuration",
              "--tcp-services-configmap=$(POD_NAMESPACE)/${var.name}-tcp-services",
              "--udp-services-configmap=$(POD_NAMESPACE)/${var.name}-udp-services",
              "--annotations-prefix=nginx.ingress.kubernetes.io",
              var.service_type == "NodePort" ? "--report-node-internal-ip-address" : "--publish-service=$(POD_NAMESPACE)/${var.name}",
              "--update-status=true",
              "--update-status-on-shutdown",
            ],
            var.extra_args
          )


          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0"
          lifecycle {
            pre_stop {
              exec {
                command = [
                  "/wait-shutdown",
                ]
              }
            }
          }
          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 10
          }
          name = var.name

          readiness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }
            period_seconds    = 10
            success_threshold = 1
            timeout_seconds   = 10
          }
          security_context {
            allow_privilege_escalation = true
            capabilities {
              add = [
                "NET_BIND_SERVICE",
              ]
              drop = [
                "ALL",
              ]
            }
            run_asuser = 101
          }

          dynamic "ports" {
            for_each = var.container_ports == null ? [] : var.container_ports
            content {
              container_port = lookup(ports.value, "container_port", null)
              host_port      = lookup(ports.value, "host_port", null)
            }
          }
        }
        node_selector = merge(
          {
            "kubernetes.io/os" = "linux"
          },
          var.node_selector
        )
        service_account_name             = var.name
        termination_grace_period_seconds = 300
      }
    }
  }
}