module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# RustFS: S3-compatible object store for local development
resource "k8s_core_v1_persistent_volume_claim" "rustfs-data" {
  metadata {
    name      = "rustfs-data"
    namespace = module.namespace.name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = var.rustfs_storage } }
  }
}

module "rustfs" {
  source    = "../../modules/generic-deployment-service"
  name      = "rustfs"
  namespace = module.namespace.name
  image     = "rustfs/rustfs:latest"

  ports = [{ name = "s3", port = 9000 }]

  env_map = {
    RUSTFS_ACCESS_KEY                    = var.rustfs_access_key
    RUSTFS_SECRET_KEY                    = var.rustfs_secret_key
    RUSTFS_ALLOW_INSECURE_DEFAULT_CREDENTIALS = "true"
  }

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.rustfs-data.metadata[0].name
      mount_path = "/data"
    }
  ]

  security_context = {
    run_asuser = 0
  }

  resources = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
    limits = {
      cpu    = "2"
      memory = "4Gi"
    }
  }
}

# ── S3 Bucket Creation Job ───────────────────────────────────────────────────

module "rustfs-bucket-job" {
  source         = "../../modules/kubernetes/job"
  name           = "${var.name}-init-bucket"
  namespace      = module.namespace.name
  image          = "quay.io/minio/mc:latest"
  restart_policy = "OnFailure"
  backoff_limit  = 4

  command = [
    "/bin/sh", "-c", <<-EOT
      # Wait for RustFS to be ready (use bash /dev/tcp since mc image has no curl/wget)
      while ! bash -c "echo > /dev/tcp/${module.rustfs.name}/9000" 2>/dev/null; do echo "Waiting for RustFS..."; sleep 2; done

      # Configure alias
      mc alias set rustfs http://${module.rustfs.name}:9000 ${var.rustfs_access_key} ${var.rustfs_secret_key}

      # Create bucket and set public read access
      mc mb --ignore-existing rustfs/${var.s3_bucket}
      mc anonymous set download rustfs/${var.s3_bucket}

      echo "Bucket ${var.s3_bucket} created and configured"
    EOT
  ]
}

# ── Omnigraph: lakehouse-native graph engine ──────────────────────────────────

module "omnigraph" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = var.image

  ports = [{ name = "http", port = 8080 }]

  env_map = {
    OMNIGRAPH_CLUSTER                 = "s3://${var.s3_bucket}/clusters/${var.graph_name}"
    OMNIGRAPH_BIND                    = "0.0.0.0:8080"
    OMNIGRAPH_SERVER_BEARER_TOKEN     = var.bearer_token
    AWS_ACCESS_KEY_ID                 = var.rustfs_access_key
    AWS_SECRET_ACCESS_KEY             = var.rustfs_secret_key
    AWS_REGION                        = var.aws_region
    AWS_ENDPOINT_URL                  = "http://${module.rustfs.name}:${module.rustfs.ports[0].port}"
    AWS_S3_FORCE_PATH_STYLE           = "true"
    AWS_ALLOW_HTTP                    = "true"
    AWS_EC2_METADATA_DISABLED         = "true"
  }

  liveness_probe = {
    initial_delay_seconds = 15
    period_seconds        = 15
    failure_threshold     = 3

    http_get = {
      path = "/healthz"
      port = 8080
    }
  }

  resources = {
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "1"
      memory = "512Mi"
    }
  }

  # ── Pod-level settings (via overrides) ───────────────────────────
  overrides = {
    # Share PID namespace so sidecar can nsenter the main process
    share_process_namespace = true
  }

  # ── InitContainers ───────────────────────────────────────────────
  init_containers = [
    # 1. Git sync at startup (alpine/git has git)
    {
      name  = "git-sync"
      image = "alpine/git:latest"

      command = [
        "/bin/sh", "-c", <<-EOT
          REPO_URL="${var.config_git_repo}"
          if [ -n "${var.git_auth_token}" ]; then
            AUTH_URL="https://${var.git_auth_token}@github.com"
            if echo "${var.config_git_repo}" | grep -q "github.com"; then
              REPO_URL=$(echo "${var.config_git_repo}" | sed "s|https://github.com|$AUTH_URL|")
            fi
          fi
          rm -rf /config/*
          git clone --depth 1 --branch ${var.config_git_branch} "$REPO_URL" /config/tmp
          mv /config/tmp/* /config/
          rm -rf /config/tmp
          echo "Config synced from ${var.config_git_repo}"
        EOT
      ]

      volume_mounts = [
        {
          name       = "config-volume"
          mount_path = "/config"
        }
      ]
    },

    # 2. Import schema (omnigraph image has omnigraph CLI)
    {
      name  = "import-schema"
      image = var.image

      env = [
        { name = "AWS_ACCESS_KEY_ID", value = var.rustfs_access_key },
        { name = "AWS_SECRET_ACCESS_KEY", value = var.rustfs_secret_key },
        { name = "AWS_REGION", value = var.aws_region },
        { name = "AWS_ENDPOINT_URL", value = "http://${module.rustfs.name}:${module.rustfs.ports[0].port}" },
        { name = "AWS_S3_FORCE_PATH_STYLE", value = "true" },
        { name = "AWS_ALLOW_HTTP", value = "true" },
        { name = "AWS_EC2_METADATA_DISABLED", value = "true" },
      ]

      command = [
        "/bin/sh", "-c", <<-EOT
          echo "Importing schema..."
          omnigraph cluster import --config /config --yes
          echo "Schema imported"
        EOT
      ]

      volume_mounts = [
        {
          name       = "config-volume"
          mount_path = "/config"
        }
      ]
    },

    # 3. Apply graph (omnigraph image has omnigraph CLI)
    {
      name  = "apply-graph"
      image = var.image

      env = [
        { name = "AWS_ACCESS_KEY_ID", value = var.rustfs_access_key },
        { name = "AWS_SECRET_ACCESS_KEY", value = var.rustfs_secret_key },
        { name = "AWS_REGION", value = var.aws_region },
        { name = "AWS_ENDPOINT_URL", value = "http://${module.rustfs.name}:${module.rustfs.ports[0].port}" },
        { name = "AWS_S3_FORCE_PATH_STYLE", value = "true" },
        { name = "AWS_ALLOW_HTTP", value = "true" },
        { name = "AWS_EC2_METADATA_DISABLED", value = "true" },
      ]

      command = [
        "/bin/sh", "-c", <<-EOT
          echo "Applying graph..."
          omnigraph cluster apply --config /config --yes
          echo "Graph applied"
        EOT
      ]

      volume_mounts = [
        {
          name       = "config-volume"
          mount_path = "/config"
        }
      ]
    },
  ]

  # ── Sidecar: Git poller ─────────────────────────────────────────
  sidecars = [
    {
      name  = "git-poller"
      image = "alpine/git:latest"

      command = [
        "/bin/sh", "-c", <<-EOT
          POLL_INTERVAL=${var.config_git_poll_interval}
          GIT_REPO="${var.config_git_repo}"
          GIT_BRANCH="${var.config_git_branch}"
          GIT_TOKEN="${var.git_auth_token}"

          # Function to find the main omnigraph process PID
          find_omnigraph_pid() {
            for pid_dir in /proc/[0-9]*/; do
              pid=$(basename "$pid_dir")
              if [ -f "/proc/$pid/cmdline" ] && grep -q "omnigraph-server" "/proc/$pid/cmdline" 2>/dev/null; then
                echo "$pid"
                return 0
              fi
            done
            return 1
          }

          # Initial clone for the sidecar
          AUTH_REPO="$GIT_REPO"
          if [ -n "$GIT_TOKEN" ]; then
            AUTH_REPO="https://$GIT_TOKEN@github.com/$(echo $GIT_REPO | sed 's|.*github.com/||')"
          fi
          cd /config && rm -rf .git repo
          git clone --depth 1 --branch "$GIT_BRANCH" "$AUTH_REPO" repo
          cd repo && git remote set-url origin "$AUTH_REPO"

          echo "Starting git poller (interval: $POLL_INTERVAL seconds)..."
          while true; do
            sleep "$POLL_INTERVAL"

            cd /config/repo
            git fetch origin "$GIT_BRANCH" 2>/dev/null
            NEW_HEAD=$(git rev-parse --verify origin/"$GIT_BRANCH")
            OLD_HEAD=$(git rev-parse HEAD)

            if [ "$NEW_HEAD" != "$OLD_HEAD" ]; then
              echo "Config change detected! $OLD_HEAD -> $NEW_HEAD"
              git pull origin "$GIT_BRANCH" --ff-only 2>/dev/null || git pull origin "$GIT_BRANCH"

              # Sync files back to shared volume
              cp -r /config/repo/* /config/

               # Since share_process_namespace=true, we can kill directly
               OMNIGRAPH_PID=$(find_omnigraph_pid)
               if [ -n "$OMNIGRAPH_PID" ] && kill -0 "$OMNIGRAPH_PID" 2>/dev/null; then
                 echo "Sending SIGTERM to omnigraph (PID: $OMNIGRAPH_PID)"
                 kill -TERM "$OMNIGRAPH_PID"
                 echo "Omnigraph restarted"
               else
                 echo "WARNING: Could not find omnigraph process"
               fi
            else
              echo "No changes detected"
            fi
          done
        EOT
      ]

      volume_mounts = [
        {
          name       = "config-volume"
          mount_path = "/config"
        }
      ]
    },
  ]

  # ── Shared config volume ────────────────────────────────────────
  # Note: volumes are used as both volume_mounts and pod volumes
  # so we need mount_path here for the containers
  volumes = [
    {
      name       = "config-volume"
      mount_path = "/config"
      empty_dir  = {}
    }
  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "omnigraph" {
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
              name = module.omnigraph.name
              port {
                number = module.omnigraph.ports[0].port
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
