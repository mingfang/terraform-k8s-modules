resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = var.replicas

  env_map = {
    POSTGRES_USER     = "sonarqube"
    POSTGRES_PASSWORD = "sonarqube"
    POSTGRES_DB       = "sonarqube"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "sonarqube_data" {
  metadata {
    name      = "sonarqube-data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    storage_class_name = "cephfs"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

resource "k8s_core_v1_persistent_volume_claim" "sonarqube_extensions" {
  metadata {
    name      = "sonarqube-extensions"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    storage_class_name = "cephfs"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

resource "k8s_core_v1_persistent_volume_claim" "sonarqube_logs" {
  metadata {
    name      = "sonarqube-logs"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    storage_class_name = "cephfs"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "sonarqube" {
  source    = "../../modules/sonarqube"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  sonarqube_data_pvc_name       = k8s_core_v1_persistent_volume_claim.sonarqube_data.metadata[0].name
  sonarqube_extensions_pvc_name = k8s_core_v1_persistent_volume_claim.sonarqube_extensions.metadata[0].name
  sonarqube_logs_pvc_name       = k8s_core_v1_persistent_volume_claim.sonarqube_logs.metadata[0].name

  SONAR_JDBC_URL      = "jdbc:postgresql://${module.postgres.name}:5432/sonarqube"
  SONAR_JDBC_USERNAME = "sonarqube"
  SONAR_JDBC_PASSWORD = "sonarqube"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.sonarqube.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.sonarqube.name
      http {
        paths {
          backend {
            service_name = module.sonarqube.name
            service_port = 9000
          }
          path = "/"
        }
      }
    }
  }
}

