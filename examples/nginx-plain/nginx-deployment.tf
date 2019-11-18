resource "k8s_apps_v1_deployment" "nginx" {
  metadata {
    labels = {
      "app"     = "nginx"
      "name"    = "nginx"
      "service" = "nginx"
    }
    name      = "nginx"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"     = "nginx"
        "name"    = "nginx"
        "service" = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          "app"     = "nginx"
          "name"    = "nginx"
          "service" = "nginx"
        }
        name      = "nginx"
        namespace = "nginx-example"
      }
      spec {
        containers {
          image             = "nginx:1.17.5"
          image_pull_policy = "IfNotPresent"
          name              = "nginx"
        }
      }
    }
  }
}