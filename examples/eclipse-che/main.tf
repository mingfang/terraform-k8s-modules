resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
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

resource "k8s_core_v1_namespace" "workspace" {
  metadata {
    name = "${var.namespace}-workspace"
  }
}

resource "k8s_core_v1_persistent_volume" "claim-che-workspace" {
  metadata {
    name = "${var.namespace}-claim-che-workspace"
  }
  spec {
    storage_class_name               = "claim-che-workspace"
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteMany"]
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

resource "k8s_core_v1_persistent_volume_claim" "claim-che-workspace" {
  metadata {
    name        = "claim-che-workspace"
    namespace   = k8s_core_v1_namespace.workspace.metadata[0].name
    annotations = { "volume-uid" = k8s_core_v1_persistent_volume.claim-che-workspace.metadata[0].uid }
  }
  spec {
    storage_class_name = k8s_core_v1_persistent_volume.claim-che-workspace.spec[0].storage_class_name
    volume_name        = k8s_core_v1_persistent_volume.claim-che-workspace.metadata[0].name
    access_modes       = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.user_storage
      }
    }
  }
}

resource "k8s_core_v1_service_account" "workspace" {
  metadata {
    name      = "che-workspace"
    namespace = k8s_core_v1_namespace.workspace.metadata[0].name
  }
}

resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "workspace" {
  metadata {
    name = "${var.namespace}-workspace"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subjects {
    kind      = "ServiceAccount"
    name      = k8s_core_v1_service_account.workspace.metadata[0].name
    namespace = k8s_core_v1_service_account.workspace.metadata[0].namespace
  }
}

module "eclipse-che" {
  source        = "../../modules/eclipse-che/eclipse-che"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class = "nginx"

  CHE_INFRA_KUBERNETES_INGRESS_DOMAIN         = "rebelsoft.com"
  CHE_INFRA_KUBERNETES_SERVICE__ACCOUNT__NAME = k8s_core_v1_service_account.workspace.metadata[0].name
  CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT      = k8s_core_v1_namespace.workspace.metadata[0].name
  CHE_INFRA_KUBERNETES_PVC_NAME               = k8s_core_v1_persistent_volume_claim.claim-che-workspace.metadata[0].name
  CHE_INFRA_KUBERNETES_PVC_STORAGE_CLASS_NAME = k8s_core_v1_persistent_volume.claim-che-workspace.spec[0].storage_class_name
}

module "devfile-registry" {
  source    = "../../modules/eclipse-che/devfile-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "plugin-registry" {
  source    = "../../modules/eclipse-che/plugin-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_extensions_v1beta1_ingress" "ingress" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "eclipse.*",
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.name
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
  }
}

resource "k8s_extensions_v1beta1_ingress" "devfile-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "devfile-registry-default.*",
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
    }
    name      = module.devfile-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.devfile-registry.service.metadata[0].name
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
  }
}

resource "k8s_extensions_v1beta1_ingress" "plugin-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "plugin-registry-default.*",
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
    }
    name      = module.plugin-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.plugin-registry.service.metadata[0].name
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
  }
}