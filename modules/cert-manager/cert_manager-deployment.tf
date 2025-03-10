resource "k8s_apps_v1_deployment" "cert_manager" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "cert-manager"
        "app.kubernetes.io/name"      = "cert-manager"
      }
    }
    template {
      metadata {
        annotations = {
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/port"   = "9402"
          "prometheus.io/scrape" = "true"
        }
        labels = {
          "app"                         = "cert-manager"
          "app.kubernetes.io/component" = "controller"
          "app.kubernetes.io/instance"  = "cert-manager"
          "app.kubernetes.io/name"      = "cert-manager"
          "app.kubernetes.io/version"   = "v1.5.1"
        }
      }
      spec {

        containers {
          args = [
            "--v=2",
            "--cluster-resource-namespace=$(POD_NAMESPACE)",
            "--leader-election-namespace=kube-system",
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "quay.io/jetstack/cert-manager-controller:v1.5.1"
          image_pull_policy = "IfNotPresent"
          name              = "cert-manager"

          ports {
            container_port = 9402
            protocol       = "TCP"
          }
          resources {
          }
        }
        security_context {
          run_asnon_root = true
        }
        service_account_name = "cert-manager"
      }
    }
  }
}