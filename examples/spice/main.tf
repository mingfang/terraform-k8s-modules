resource "k8s_core_v1_namespace" "spice" {
  metadata {
    name = var.namespace
  }
}
module "spice-config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "spice-config"
  namespace = k8s_core_v1_namespace.spice.metadata[0].name
  from-dir  = "${path.module}/config"
}

module "spice" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = k8s_core_v1_namespace.spice.metadata.0.name
  image     = "spiceai/spiceai:latest"
  ports     = [{name = "tcp", port = 3000}]
  command   = [
     "/usr/local/bin/spiced",
     "--http",
     "0.0.0.0:3000",
     "--metrics",
     "0.0.0.0:9000",
     "--flight",
     "0.0.0.0:50051",
     "--open_telemetry",
     "0.0.0.0:50052"
   ]
  configmap = module.spice-config.config_map
  configmap_mount_path = "/app"
}

resource "k8s_networking_k8s_io_v1_ingress" "spice" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.spice.metadata.0.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.spice.name
              port {
                number = module.spice.ports.0.port
              }
            }
          }
          path = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
