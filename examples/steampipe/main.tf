resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/config"
}

module "steampipe" {
  source    = "../../modules/steampipe"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  sidecars = [
    {
      name  = "dind"
      image = "docker:dind-rootless"
      args  = ["--insecure-registry=0.0.0.0/0", "--group=1000", "--log-level=fatal"]
      env   = [{ name = "DOCKER_TLS_CERTDIR", value = "" }]

      security_context = {
        privileged  = true
        run_asuser  = 1000
        run_asgroup = 1000
      }
    }
  ]

  configmap            = module.config.config_map
  configmap_mount_path = "/home/steampipe/.steampipe/config"

  #  https://steampipe.io/docs/reference/env-vars/overview
  env_map = {
    STEAMPIPE_DATABASE_PASSWORD = "steampipe"
    DOCKER_HOST                 = "tcp://localhost:2375"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.steampipe.name
            service_port = module.steampipe.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
