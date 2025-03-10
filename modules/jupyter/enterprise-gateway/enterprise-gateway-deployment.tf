resource "k8s_apps_v1_deployment" "enterprise-gateway" {
  metadata {
    labels = {
      "app"              = "enterprise-gateway"
      "component"        = "enterprise-gateway"
      "gateway-selector" = "enterprise-gateway"
    }
    name      = "enterprise-gateway"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "gateway-selector" = "enterprise-gateway"
      }
    }
    template {
      metadata {
        labels = {
          "app"              = "enterprise-gateway"
          "component"        = "enterprise-gateway"
          "gateway-selector" = "enterprise-gateway"
        }
      }
      spec {

        containers {

          env {
            name  = "EG_PORT"
            value = "8888"
          }
          env {
            name  = "EG_NAMESPACE"
            value = var.namespace
          }
          env {
            name  = "EG_KERNEL_CLUSTER_ROLE"
            value = "kernel-controller"
          }
          env {
            name  = "EG_SHARED_NAMESPACE"
            value = "True"
          }
          env {
            name  = "EG_MIRROR_WORKING_DIRS"
            value = "False"
          }
          env {
            name  = "EG_CULL_IDLE_TIMEOUT"
            value = "3600"
          }
          env {
            name  = "EG_LOG_LEVEL"
            value = "INFO"
          }
          env {
            name  = "EG_KERNEL_LAUNCH_TIMEOUT"
            value = "60"
          }
          env {
            name  = "EG_KERNEL_WHITELIST"
            value = "['r_kubernetes','python_kubernetes','python_tf_kubernetes','python_tf_gpu_kubernetes','scala_kubernetes','spark_r_kubernetes','spark_python_kubernetes','spark_scala_kubernetes']"
          }
          env {
            name  = "EG_UID_BLACKLIST"
            value = "-1"
          }
          image             = "elyra/enterprise-gateway:dev"
          image_pull_policy = "Always"
          name              = "enterprise-gateway"

          ports {
            container_port = 8888
          }
        }
        service_account_name = "enterprise-gateway-sa"
      }
    }
  }
}