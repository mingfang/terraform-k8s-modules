resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      app       = "che"
      component = "che"
    }
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "nfs-provisioner" {
  source        = "../../modules/nfs-provisioner-empty-dir"
  name          = "nfs-provisioner"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = k8s_core_v1_namespace.this.metadata[0].name
}

module "postgres-storage" {
  source        = "../../modules/kubernetes/storage-nfs"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata[0].uid
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = module.postgres-storage.storage_class_name
  storage       = module.postgres-storage.storage
  replicas      = module.postgres-storage.replicas
  //  image         = "postgres:9.6.16"

  POSTGRES_USER     = "pgche"
  POSTGRES_PASSWORD = "pgchepassword"
  POSTGRES_DB       = "dbche"
}

resource "k8s_core_v1_persistent_volume" "che-data-volume" {
  metadata {
    name = "${var.namespace}-che-data-volume"
  }
  spec {
    storage_class_name               = "che-data-volume"
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteOnce"]
    capacity = {
      storage = var.user_storage
    }
    nfs {
      path   = "/"
      server = module.nfs-server.service.spec[0].cluster_ip
    }
    mount_options = module.nfs-server.mount_options
  }
}

resource "k8s_core_v1_persistent_volume_claim" "che_data_volume" {
  metadata {
    name        = "che-data-volume"
    namespace   = k8s_core_v1_namespace.this.metadata[0].name
    annotations = { "volume-uid" = k8s_core_v1_persistent_volume.che-data-volume.metadata[0].uid }
  }
  spec {
    storage_class_name = k8s_core_v1_persistent_volume.che-data-volume.spec[0].storage_class_name
    volume_name        = k8s_core_v1_persistent_volume.che-data-volume.metadata[0].name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.user_storage
      }
    }
  }
}

module "eclipse-che" {
  source        = "../../modules/eclipse-che/eclipse-che"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class = "nginx"

  CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME    = "cluster-admin"
  CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT      = "${var.namespace}-<username>"
  CHE_INFRA_KUBERNETES_PVC_STORAGE_CLASS_NAME = module.nfs-provisioner.storage_class

  CHE_INFRA_KUBERNETES_TLS__ENABLED    = true
  CHE_HOST                             = "eclipse.rebelsoft.com"
  CHE_WORKSPACE_DEVFILE__REGISTRY__URL = "https://devfile-registry.rebelsoft.com"
  CHE_WORKSPACE_PLUGIN__REGISTRY__URL  = "https://plugin-registry.rebelsoft.com/v3"
  /*
  Depends on examples/keycloak
  */
  CHE_MULTIUSER                  = true
  CHE_KEYCLOAK_AUTH__SERVER__URL = "https://keycloak.rebelsoft.com/auth"
  CHE_KEYCLOAK_REALM             = "eclipse-che"
  CHE_KEYCLOAK_CLIENT__ID        = "eclipse-che"
}

module "devfile-registry" {
  source    = "../../modules/eclipse-che/devfile-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "plugin-registry" {
  source    = "../../modules/eclipse-che/plugin-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_extensions_v1beta1_ingress" "che" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "eclipse.*"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
      "certmanager.k8s.io/cluster-issuer"                 = "letsencrypt-prod"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "eclipse.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.eclipse-che.service.metadata[0].name
            service_port = module.eclipse-che.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "eclipse.rebelsoft.com"
      ]
      secret_name = "${var.name}-tls"
    }
  }
}

resource "k8s_extensions_v1beta1_ingress" "devfile-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "devfile-registry.*",
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
      "certmanager.k8s.io/cluster-issuer"                 = "letsencrypt-prod"
    }
    name      = module.devfile-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "devfile-registry.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.devfile-registry.service.metadata[0].name
            service_port = module.devfile-registry.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "devfile-registry.rebelsoft.com"
      ]
      secret_name = "${var.name}-devfile-registry-tls"
    }

  }
}

resource "k8s_extensions_v1beta1_ingress" "plugin-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "plugin-registry.*",
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
      "certmanager.k8s.io/cluster-issuer"                 = "letsencrypt-prod"
    }
    name      = module.plugin-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "plugin-registry.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.plugin-registry.service.metadata[0].name
            service_port = module.plugin-registry.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }

    tls {
      hosts = [
        "plugin-registry.rebelsoft.com"
      ]
      secret_name = "${var.name}-plugin-registry-tls"
    }
  }
}