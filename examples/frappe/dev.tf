resource "k8s_core_v1_persistent_volume_claim" "dev" {
  metadata {
    name      = "dev"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        "storage" = "1Gi"
      }
    }
    storage_class_name = var.storage_class_name
  }
}

module "dev-server" {
  source    = "../../modules/frappe/dev-server"
  name      = "dev-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  MARIADB_HOST        = module.mysql.name
  DB_PORT             = module.mysql.ports[0].port
  DB_ROOT_USER        = "root"
  MYSQL_ROOT_PASSWORD = "frappe"

  /* if using postgres
  POSTGRES_HOST      = module.postgres.name
  DB_PORT            = module.postgres.ports[0].port
  DB_ROOT_USER       = "frappe"
  POSTGRES_PASSWORD  = "frappe"
  */

  REDIS_CACHE    = "${module.redis-cache.name}:${module.redis-cache.ports[0].port}"
  REDIS_QUEUE    = "${module.redis-queue.name}:${module.redis-queue.ports[0].port}"
  REDIS_SOCKETIO = "${module.redis-socketio.name}:${module.redis-socketio.ports[0].port}"
  SOCKETIO_PORT  = 443
  pvc_sites      = k8s_core_v1_persistent_volume_claim.dev.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "dev" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "frappe-dev.*"
    }
    name      = module.dev-server.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.dev-server.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.dev-server.name
            service_port = module.dev-server.ports[0].port
          }
          path = "/"
        }
        paths {
          backend {
            service_name = module.dev-server.name
            service_port = module.dev-server.ports[1].port
          }
          path = "/socket.io"
        }
      }
    }
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

module "intellij" {
  source    = "../../modules/intellij"
  name      = "intellij"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    },
    {
      name  = "ORG_JETBRAINS_PROJECTOR_SERVER_HANDSHAKE_TOKEN"
      value = "write"
    },
    {
      name  = "ORG_JETBRAINS_PROJECTOR_SERVER_RO_HANDSHAKE_TOKEN"
      value = "read"
    },
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

  pvc = k8s_core_v1_persistent_volume_claim.dev.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "intellij" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "frappe-intellij.*"
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
          backend {
            service_name = module.intellij.name
            service_port = module.intellij.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
