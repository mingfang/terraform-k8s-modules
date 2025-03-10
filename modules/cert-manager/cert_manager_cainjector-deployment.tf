resource "k8s_apps_v1_deployment" "cert_manager_cainjector" {
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "cainjector"
        "app.kubernetes.io/instance"  = "cert-manager"
        "app.kubernetes.io/name"      = "cainjector"
      }
    }
    template {
      metadata {
        labels = {
          "app"                         = "cainjector"
          "app.kubernetes.io/component" = "cainjector"
          "app.kubernetes.io/instance"  = "cert-manager"
          "app.kubernetes.io/name"      = "cainjector"
          "app.kubernetes.io/version"   = "v1.5.1"
        }
      }
      spec {

        containers {
          args = [
            "--v=2",
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
          image             = "quay.io/jetstack/cert-manager-cainjector:v1.5.1"
          image_pull_policy = "IfNotPresent"
          name              = "cert-manager"
          resources {
          }
        }
        security_context {
          run_asnon_root = true
        }
        service_account_name = "cert-manager-cainjector"
      }
    }
  }
}