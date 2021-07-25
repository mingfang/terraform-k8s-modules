resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

// grant admin to this namespace
resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "admin" {
  metadata {
    name      = "admin"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  subjects {
    kind = "ServiceAccount"
    name = "default"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

// volume to store project files
resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

// IntelliJ with Docker In Docker(DinD) support
module "intellij" {
  source    = "../../modules/intellij"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    }
  ]

  // add additional containers for your project such as db, messaging, etc
  additional_containers = [
    {
      name  = "dind"
      image = "docker:19-dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
      }

      volume_mounts = [
        {
          name          = "data"
          mount_path    = "/var/lib/docker"
          sub_path_expr = ".docker/$(POD_NAME)/var/lib/docker"
        },
      ]
    }
  ]

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

// IntelliJ URL https://<namespace>.<your domain>
resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.intellij.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.intellij.name}-${var.namespace}"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.intellij.name
            service_port = module.intellij.ports[0].port
          }
        }
      }
    }
  }
}

// Proxy to any port https://<namespace>-<port>.<your domain>
resource "k8s_networking_k8s_io_v1beta1_ingress" "proxy" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"

      "nginx.ingress.kubernetes.io/server-snippet" = <<-EOF
        server_name ~^${var.namespace}-(?<port>[0-9]+)\..*;
        location ~ / {
          resolver kube-dns.kube-system.svc.cluster.local valid=5s;
          proxy_pass http://${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local:$port;
        }
        EOF
    }
    name      = "${module.intellij.name}-proxy"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.intellij.name}-${var.namespace}-proxy"
      http {
        // not used; only to avoid syntax validation error
        paths {
          path = "/"
          backend {
            service_name = module.intellij.name
            service_port = module.intellij.ports[0].port
          }
        }
      }
    }
  }
}

