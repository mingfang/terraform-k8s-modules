module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# Shared persistent volume for DAG definitions and data
resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data-volume"
    namespace = module.namespace.name
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

# Server — web UI + embedded coordinator (start-all)
# Follows official dagucloud/dagu deploy/k8s/server-deployment.yaml
# ConfigMap — contains the git-sync DAG definition
module "git_sync_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "git-sync-dag"
  namespace = module.namespace.name
  from-map = {
    "git-sync-dag.yaml" = templatefile("${path.module}/dags/git-sync-dag.yaml", {
      namespace     = var.namespace
      git_sync_repo = var.git_sync_repo
    })
  }
}

# GitHub PAT secret — used by git-sync DAG to authenticate with GitHub
resource "k8s_core_v1_secret" "git_token" {
  metadata {
    name      = "dagu-git-token"
    namespace = module.namespace.name
  }
  string_data = {
    "github-pat" = var.github_pat
  }
}

module "dagu" {
  source    = "../../modules/generic-deployment-service"
  name      = "dagu"
  namespace = module.namespace.name
  image     = var.image

  ports_map = { http = 8080, grpc = 50055 }

  command = ["dagu"]
  args    = ["start-all"]

  env_map = {
    # Server config
    DAGU_HOST          = "0.0.0.0"
    DAGU_PORT          = "8080"
    DAGU_DAGS_DIR      = "/var/lib/dagu/dags"
    DAGU_HOME          = "/var/lib/dagu"
    DAGU_PEER_INSECURE = "true"
    DOCKER_HOST        = "tcp://localhost:2375"

    DAGU_DEFAULT_EXECUTION_MODE = "distributed"
    DAGU_WORKER_MAX_ACTIVE_RUNS = "20"

    # Coordinator config (enables distributed mode)
    DAGU_COORDINATOR_HOST      = "0.0.0.0"
    DAGU_COORDINATOR_ADVERTISE = "dagu"
    DAGU_COORDINATOR_PORT      = "50055"
  }

  pvcs = [{
    name       = "data-volume"
    mount_path = "/var/lib/dagu"
  }]

  role_rules = [{
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
  }]
}

# Uses StatefulSet for stable worker IDs: dagu-worker-0, dagu-worker-1
# vs Deployment random names that change on recreate
module "dagu-worker" {
  source    = "../../modules/generic-statefulset-service"
  name      = "dagu-worker"
  namespace = module.namespace.name
  image     = var.image

  ports_map = { health = 8092 }
  replicas  = 1

  command = ["dagu"]
  args    = ["worker", "--worker.coordinators=dagu:50055", "--peer.insecure"]

  env_map = {
    DAGU_HOST     = "0.0.0.0"
    DAGU_PORT     = "8080"
    DAGU_DAGS_DIR = "/var/lib/dagu/dags"
    DAGU_HOME     = "/var/lib/dagu"
    DOCKER_HOST   = "tcp://localhost:2375"
    DAGU_WORKER_MAX_ACTIVE_RUNS = "6"
  }

  startup_probe = {
    initial_delay_seconds = 5
    period_seconds        = 3
    timeout_seconds       = 2
    failure_threshold     = 20

    tcp_socket = {
      port = 2375
    }
  }

  env = [{
    name = "DAGU_WORKER_ID"
    value_from = {
      field_ref = {
        field_path = "metadata.name"
      }
    }
  }]

  pvcs = [{
    name       = "data-volume"
    mount_path = "/var/lib/dagu"
  }]

  sidecars = [
    {
      name  = "dind"
      image = "docker:dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env = [
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
        run_asuser = 0
      }

      volume_mounts = [
        {
          name       = "data-volume"
          mount_path = "/var/lib/dagu/docker"
        },
      ]

      startup_probe = {
        initial_delay_seconds = 2
        period_seconds        = 2
        timeout_seconds       = 2
        failure_threshold     = 30

        tcp_socket = {
          port = 2375
        }
      }
    }
  ]

  configmap = {
    metadata = [{
      name = module.git_sync_config.name
    }]
    data = {
      "git-sync-dag.yaml" = module.git_sync_config.config_map.data["git-sync-dag.yaml"]
    }
  }

  configmap_mount_path = "/var/lib/dagu/dags"

  role_rules = [{
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
  }]
}

# Ingress — exposes the DAGU web UI
resource "k8s_networking_k8s_io_v1_ingress" "app" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.dagu.name
              port {
                number = module.dagu.ports_map.http
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

