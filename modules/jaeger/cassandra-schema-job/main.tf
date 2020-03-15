resource "k8s_batch_v1beta1_cron_job" "this" {

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    job_template {
      spec {
        template {
          spec {
            containers {
              name  = var.name
              image = var.image
              env {
                name  = "MODE"
                value = "prod"
              }
              env {
                name  = "DATACENTER"
                value = "dc1"
              }
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
    schedule = "*/5 * * * *"
  }
}