resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class_name
  storage       = "1Gi"
  replicas      = 1

  env_map = {
    POSTGRES_USER     = "pgche"
    POSTGRES_PASSWORD = "pgchepassword"
    POSTGRES_DB       = "dbche"
  }
}

module "eclipse-che" {
  source        = "../../modules/eclipse-che/eclipse-che"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class = "nginx"

  CHE_SYSTEM_ADMIN__NAME                        = "mingfang"
  CHE_INFRA_KUBERNETES_CLUSTER__ROLE__NAME      = "cluster-admin"
  CHE_INFRA_KUBERNETES_NAMESPACE_DEFAULT        = "${var.namespace}-<username>"
  CHE_INFRA_KUBERNETES_PVC_STORAGE__CLASS__NAME = var.storage_class_name

  CHE_HOST                             = "che.${var.namespace}.rebelsoft.com"
  CHE_WORKSPACE_DEVFILE__REGISTRY__URL = "https://devfile-registry.${var.namespace}.rebelsoft.com"
  CHE_WORKSPACE_PLUGIN__REGISTRY__URL  = "https://plugin-registry.${var.namespace}.rebelsoft.com/v3"

  /*
  Ingress strategy
  Domain only needed when strategy is multi-host
  */
  CHE_INFRA_KUBERNETES_SERVER__STRATEGY        = "multi-host"
  CHE_INFRA_KUBERNETES_INGRESS_DOMAIN          = "${var.namespace}.rebelsoft.com"
  CHE_INFRA_KUBERNETES_INGRESS_PATH__TRANSFORM = null

  /*
  Depends on keycloak
  */
  CHE_MULTIUSER                  = true
  CHE_KEYCLOAK_AUTH__SERVER__URL = "https://keycloak.rebelsoft.com/auth/realms/${var.namespace}"
  CHE_KEYCLOAK_REALM             = var.namespace
  CHE_KEYCLOAK_CLIENT__ID        = var.namespace

  // run as root
  CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_FS__GROUP     = "0"
  CHE_INFRA_KUBERNETES_POD_SECURITY__CONTEXT_RUN__AS__USER = "0"

  // TLS
  CHE_INFRA_KUBERNETES_TLS__ENABLED = true
  CHE_INFRA_KUBERNETES_TLS__KEY     = base64decode(data.k8s_core_v1_secret.wildcard.data["tls.key"])
  CHE_INFRA_KUBERNETES_TLS__CERT    = base64decode(data.k8s_core_v1_secret.wildcard.data["tls.crt"])
}

resource "k8s_cert_manager_io_v1alpha2_certificate" "wildcard" {
  metadata {
    name      = "wildcard.${var.namespace}.rebelsoft.com"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    secret_name = "wildcard.${var.namespace}.rebelsoft.com"
    issuer_ref {
      group = "cert-manager.io"
      kind  = "ClusterIssuer"
      name  = "letsencrypt-prod-dns"
    }
    dns_names = [
      "*.${var.namespace}.rebelsoft.com",
    ]
  }
}

data "k8s_core_v1_secret" "wildcard" {
  metadata {
    name      = k8s_cert_manager_io_v1alpha2_certificate.wildcard.spec[0].secret_name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
}

module "devfile-registry" {
  source    = "../../modules/eclipse-che/devfile-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
#  image     = "registry.rebelsoft.com/devfile-registry:latest"
}

module "plugin-registry" {
  source    = "../../modules/eclipse-che/plugin-registry"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
#  image     = "registry.rebelsoft.com/plugin-registry:latest"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "che" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
      "cert-manager.io/cluster-issuer"                    = "letsencrypt-prod"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "che.${var.namespace}.rebelsoft.com"
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
        "che.${var.namespace}.rebelsoft.com",
      ]
      secret_name = "che.${var.namespace}.rebelsoft.com"
    }
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "devfile-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "cert-manager.io/cluster-issuer"                    = "letsencrypt-prod"
    }
    name      = module.devfile-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "devfile-registry.${var.namespace}.rebelsoft.com"
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
        "devfile-registry.${var.namespace}.rebelsoft.com"
      ]
      secret_name = "devfile-registry.${var.namespace}.rebelsoft.com"
    }

  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "plugin-registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "cert-manager.io/cluster-issuer"                    = "letsencrypt-prod"
    }
    name      = module.plugin-registry.service.metadata[0].name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "plugin-registry.${var.namespace}.rebelsoft.com"
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
        "plugin-registry.${var.namespace}.rebelsoft.com"
      ]
      secret_name = "plugin-registry.${var.namespace}.rebelsoft.com"
    }
  }
}