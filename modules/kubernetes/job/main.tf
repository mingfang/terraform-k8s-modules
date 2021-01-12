variable "name" {}

variable "namespace" {}

variable "command" {}

variable image {}

variable restart_policy {
  default = "Never"
}

variable backoff_limit {
  default = 4
}

resource "k8s_batch_v1_job" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    template {
      spec {
        containers {
          name    = "job"
          image   = var.image
          command = var.command
        }

        restart_policy = var.restart_policy
      }
    }

    backoff_limit = var.backoff_limit
  }
}
