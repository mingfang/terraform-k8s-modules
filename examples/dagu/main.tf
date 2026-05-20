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
  source      = "../../modules/kubernetes/config-map"
  name        = "git-sync-dag"
  namespace   = module.namespace.name
  from-map    = {
    "git-sync-dag.yaml" = templatefile("${path.module}/dags/git-sync-dag.yaml", {
      namespace      = var.namespace
      git_sync_repo  = var.git_sync_repo
    })
  }
}

module "dagu" {
  source    = "../../modules/generic-deployment-service"
  name      = "dagu"
  namespace = module.namespace.name
  image     = "ghcr.io/dagucloud/dagu:latest"

  ports_map = { http = 8080, grpc = 50055 }

  command = ["dagu"]
  args    = ["start-all"]

  env_map = {
    # Server config
    DAGU_HOST           = "0.0.0.0"
    DAGU_PORT           = "8080"
    DAGU_DAGS_DIR       = "/var/lib/dagu/dags"
    DAGU_HOME           = "/var/lib/dagu"
    DAGU_PEER_INSECURE  = "true"
    DOCKER_HOST         = "unix:///dind/docker.sock"

    # Coordinator config (enables distributed mode)
    DAGU_COORDINATOR_HOST        = "0.0.0.0"
    DAGU_COORDINATOR_ADVERTISE   = "dagu"
    DAGU_COORDINATOR_PORT        = "50055"
  }

  pvcs = [{
    name       = "data-volume"
    mount_path = "/var/lib/dagu"
  }]

  sidecars = [
    {
      name  = "dind"
      image = "docker:dind-rootless"
      args  = ["--group=1000", "--log-level=fatal", "--storage-driver=vfs"]
      env = [
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
          name       = "docker-sock"
          mount_path = "/dind"
        },
        {
          name       = "data-volume"
          mount_path = "/dind/docker-shared/dags"
        },
      ]
    }
  ]

  volumes = [
    {
      name = "docker-sock"
      empty_dir = {
        medium    = "Memory"
        sizeLimit = "1G"
      }
      mount_path = "/dind"
    },
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
    api_groups  = [""]
    resources   = ["secrets"]
    verbs       = ["get"]
  }]
}

# Uses StatefulSet for stable worker IDs: dagu-worker-0, dagu-worker-1
# vs Deployment random names that change on recreate
module "dagu-worker" {
  source    = "../../modules/generic-statefulset-service"
  name      = "dagu-worker"
  namespace = module.namespace.name
  image     = "ghcr.io/dagucloud/dagu:latest"

  ports_map = { health = 8092 }
  replicas  = 2

  command = ["dagu"]
  args    = ["worker", "--worker.coordinators=dagu:50055", "--peer.insecure"]

  env_map = {
    DAGU_HOST     = "0.0.0.0"
    DAGU_PORT     = "8080"
    DAGU_DAGS_DIR = "/var/lib/dagu/dags"
    DAGU_HOME     = "/var/lib/dagu"
    DOCKER_HOST   = "unix:///dind/docker.sock"
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
      image = "docker:dind-rootless"
      args  = ["--group=1000", "--log-level=fatal", "--storage-driver=vfs"]
      env = [
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
          name       = "docker-sock"
          mount_path = "/dind"
        },
        {
          name       = "data-volume"
          mount_path = "/dind/docker-shared/dags"
        },
      ]
    }
  ]

  volumes = [
    {
      name = "docker-sock"
      empty_dir = {
        medium    = "Memory"
        sizeLimit = "1G"
      }
      mount_path = "/dind"
    },
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
    api_groups  = [""]
    resources   = ["secrets"]
    verbs       = ["get"]
  }]
}

# Ingress — exposes the DAGU web UI
resource "k8s_networking_k8s_io_v1_ingress" "app" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-app"
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
