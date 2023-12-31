resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  image     = "registry.rebelsoft.com/postgres:16"

  storage_class = "cephfs"
  storage       = "1Gi"

  args = [
    "-c", "work_mem=256MB",
    "-c", "maintenance_work_mem=256MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
  ]
  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}
resource "k8s_core_v1_persistent_volume_claim" "kestra-wd" {
  metadata {
    name      = "kestra-wd"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "kestra" {
  source    = "../../modules/kestra"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name


  sidecars = [
    {
      name  = "dind"
      image = "docker:dind-rootless"
      args  = ["--group=1000", "--log-level=fatal"]
      env   = [
        {
          name       = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        },
        {
          name  = "DOCKER_HOST"
          value = "unix:///dind/docker.sock"
        }
      ]
      security_context = {
        privileged  = true
        run_asuser  = 1000
        run_asgroup = 1000
      }

      volume_mounts = [
        {
          name       = k8s_core_v1_persistent_volume_claim.kestra-wd.metadata[0].name
          mount_path = "/tmp/kestra-wd"
        },
        {
          name       = "docker-sock"
          mount_path = "/dind"
        },
      ]
    }
  ]

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
      mount_path = "/app/storage"
    },
    {
      name       = k8s_core_v1_persistent_volume_claim.kestra-wd.metadata[0].name
      mount_path = "/tmp/kestra-wd"
    },
  ]

  volumes = [
    {
      name      = "docker-sock"
      empty_dir = {
        medium    = "Memory"
        sizeLimit = "1G"
      }
      mount_path = "/dind"
    },
  ]

  env_map = {
    DOCKER_HOST          = "unix:///dind/docker.sock"
    KESTRA_CONFIGURATION = <<-EOF
        datasources:
          postgres:
            url: jdbc:postgresql://${module.postgres.name}:5432/postgres
            driverClassName: org.postgresql.Driver
            username: postgres
            password: postgres
        kestra:
          server:
            basic-auth:
              enabled: false
              username: "admin@kestra.io" # it must be a valid email address
              password: kestra
          repository:
            type: postgres
          storage:
            type: local
            local:
              base-path: "/app/storage"
          queue:
            type: postgres
          tasks:
            tmp-dir:
              path: /tmp/kestra-wd/tmp
          url: http://localhost:8080/
    EOF
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
            service_name = module.kestra.name
            service_port = module.kestra.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
