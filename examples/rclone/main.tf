module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = var.name
  namespace = module.namespace.name
  from-dir  = "${path.module}/config"
}

module "nginx" {
  source    = "../../modules/generic-deployment-service"
  name      = "nginx"
  namespace = module.namespace.name
  image     = "nginx"
  ports     = [{ name = "tcp", port = 80 }]
  configmap = module.config.config_map

  sidecars = [
    {
      name  = "mounter"
      image = "rclone/rclone"
      command = ["sh", "-c", <<-EOF
        mkdir -p /rclone/mnt
        exec rclone mount s3: /rclone/mnt --allow-other
        EOF
      ]
      life_cyle = {
        pre_stop = ["umount", "-all"]
      }
      security_context = {
        privileged = true
      }
      volume_mounts = [
        {
          name       = "config"
          mount_path = "/config/rclone/rclone.conf"
          sub_path   = "rclone.conf"
        },
        {
          name              = "rclone"
          mount_path        = "/rclone"
          mount_propagation = "Bidirectional"
        }
      ]
    }
  ]
  volumes = [
    {
      name = "rclone"
      empty_dir = {
        sizeLimit = "1G"
      }
      mount_path        = "/usr/share/nginx/html"
      mount_propagation = "HostToContainer"
    }
  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.nginx.name
              port {
                number = module.nginx.ports.0.port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
