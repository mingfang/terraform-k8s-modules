resource "k8s_apps_v1_deployment" "cert_manager_cainjector" {
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
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
          image             = "quay.io/jetstack/cert-manager-cainjector:v1.2.0"
          image_pull_policy = "IfNotPresent"
          name              = "cert-manager"
          resources {
          }
        }
        service_account_name = "cert-manager-cainjector"
      }
    }
  }
}