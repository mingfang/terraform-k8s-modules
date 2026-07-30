# AgentENV — Kubernetes deployment of the AgentENV stack
# (https://kvcache-ai.github.io/AgentENV/deployment/kubernetes.html)
#
# Architecture (matches the upstream k8s base manifests):
#
#   ingress (:8080)
#     |
#   agentenv-gateway (Deployment)  ──► agentenv-scheduler (Deployment, gRPC :9090)
#                                        │ discovers nodes via EndpointSlices for
#                                        │ the headless `agentenv-nodes` Service
#                                        ▼
#   agentenv-node (DaemonSet, privileged)  ── one pod per KVM node (:8000)
#
# The runtime runs as a DaemonSet because each pod needs host-local /dev/kvm,
# host iptables/network namespaces, and per-host state at /var/lib/aenv.

module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ----------------------------------------------------------------------------
# Config maps
# ----------------------------------------------------------------------------

# Runtime config — the repo's config/default.toml, mounted verbatim.
module "runtime_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "agentenv-runtime-config"
  namespace = module.namespace.name
  from-file = "${path.module}/config/default.toml"
}

# Scheduler config — uses Kubernetes discovery (watches EndpointSlices for the
# headless `agentenv-nodes` Service) instead of a static node list.
module "scheduler_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "agentenv-scheduler-config"
  namespace = module.namespace.name
  from-map = {
    "scheduler.json" = jsonencode({
      log_level  = "info"
      log_format = "json"
      scheduler = {
        grpc_listen_addr = ":9090"
        strategy         = "round_robin"
        discovery = {
          mode = "kubernetes"
          kubernetes = {
            namespace    = module.namespace.name
            service_name = "agentenv-nodes"
            port         = 8000
            scheme       = "http"
          }
        }
      }
    })
  }
}

# Gateway config — forwards to the scheduler at agentenv-scheduler:9090.
module "gateway_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "agentenv-gateway-config"
  namespace = module.namespace.name
  from-map = {
    "gateway.json" = jsonencode({
      log_level  = "info"
      log_format = "json"
      gateway = {
        http_listen_addr      = ":8080"
        scheduler_addr        = "agentenv-scheduler:9090"
        request_timeout       = "90s"
        forward_response_size = 4194304
        sandbox_proxy_domains = []
      }
    })
  }
}

# ----------------------------------------------------------------------------
# Runtime node — DaemonSet (one privileged pod per KVM node)
# ----------------------------------------------------------------------------

locals {
  # preStop drains sandboxes before the pod terminates; postStart disables
  # cgroup v2 memory.oom.group so a firecracker child OOM doesn't kill the server.
  node_lifecycle = {
    post_start = {
      exec = {
        command = ["/bin/sh", "-c", "CGROUP=\"$(awk -F: '/^0::/{print $3}' /proc/self/cgroup)\" && echo 0 > /sys/fs/cgroup/$CGROUP/memory.oom.group"]
      }
    }
    pre_stop = {
      exec = {
        command = [
          "/bin/sh", "-c",
          "echo \"preStop: waiting for sandboxes to drain...\"; while true; do count=$(curl -sf -H 'X-API-Key: preStop' http://localhost:8000/sandboxes | jq 'length') || count=\"\"; if [ -z \"$count\" ]; then sleep 3; continue; fi; if [ \"$count\" = \"0\" ]; then break; fi; sleep 3; done",
        ]
      }
    }
  }

  node_probes = {
    startup_probe = {
      http_get          = { path = "/health", port = 8000 }
      period_seconds    = 5
      timeout_seconds   = 5
      failure_threshold = 48
    }
    readiness_probe = {
      http_get        = { path = "/health", port = 8000 }
      period_seconds  = 5
      timeout_seconds = 3
    }
    liveness_probe = {
      http_get        = { path = "/health", port = 8000 }
      period_seconds  = 20
      timeout_seconds = 5
    }
  }
}

module "agentenv_node" {
  source    = "../../modules/generic-daemonset"
  name      = "agentenv-node"
  namespace = module.namespace.name
  image     = var.runtime_image

  node_selector = var.runtime_node_selector

  env = [
    { name = "AENV_CONFIG_PATH", value = "/workspace/config/default.toml" },
    { name = "API_ADDR", value = "0.0.0.0:8000" },
    { name = "AENV_UBLK_DAEMON_BINARY_PATH", value = "/usr/local/bin/uvm-ublk-daemon" },
    { name = "AENV_UBLK_DAEMON_METRICS_LISTEN_ADDR", value = "0.0.0.0:9103" },
    {
      name       = "AENV_NODE_ID"
      value_from = { field_ref = { field_path = "metadata.name" } }
    },
    { name = "AENV_OBSERVABILITY_SCHEDULER_REPORT_ENABLED", value = "true" },
    { name = "AENV_OBSERVABILITY_SCHEDULER_ENDPOINT", value = "http://agentenv-scheduler:9090" },
    { name = "AENV_SANDBOX_PROXY_DOMAINS", value = var.sandbox_proxy_domains },
  ]

  resources = {
    requests = { memory = "8Gi" }
  }

  security_context = { privileged = true }

  # Privileged initContainer: the server validates that host IPv4 forwarding is
  # enabled and bails if it isn't (`server --setup-host` does this on bare
  # metal). The container is privileged, so it can write host sysctls directly.
  init_containers = [
    {
      name  = "host-setup"
      image = "alpine:3.21"

      command = [
        "sh", "-cx",
        <<-EOF
          sysctl -w net.ipv4.ip_forward=1
          modprobe nf_conntrack 2>/dev/null || true
          sysctl -w net.ipv4.neigh.default.gc_thresh1=4096
          sysctl -w net.ipv4.neigh.default.gc_thresh2=8192
          sysctl -w net.ipv4.neigh.default.gc_thresh3=16384
          sysctl -w net.netfilter.nf_conntrack_max=1048576
          sysctl -w kernel.pid_max=4194304
          sysctl -w fs.inotify.max_user_instances=8192
        EOF
      ]

      security_context = {
        privileged = true
        run_asuser = "0"
      }
    },
  ]

  startup_probe   = local.node_probes.startup_probe
  readiness_probe = local.node_probes.readiness_probe
  liveness_probe  = local.node_probes.liveness_probe
  _lifecycle      = local.node_lifecycle

  # Pod-level volumes (host-local state + /dev for KVM/ublk).
  volumes = [
    {
      name = "workspace"
      host_path = {
        path = "/var/lib/aenv"
        type = "DirectoryOrCreate"
      }
      mount_path = "/workspace"
    },
    {
      name = "host-dev"
      host_path = {
        path = "/dev"
        type = "Directory"
      }
      mount_path = "/dev"
    },
  ]

  # config/default.toml -> /workspace/config/default.toml (subPath per key)
  configmap            = module.runtime_config.config_map
  configmap_mount_path = "/workspace/config"
}

# Headless Service — the scheduler watches EndpointSlices for this service to
# discover runtime node pods. publishNotReadyAddresses keeps endpoints present
# while pods are still starting (the runtime startup probe is slow).
resource "k8s_core_v1_service" "agentenv_nodes" {
  metadata {
    name      = "agentenv-nodes"
    namespace = module.namespace.name
    labels = {
      name = "agentenv-node"
    }
  }

  spec {
    cluster_ip                  = "None"
    publish_not_ready_addresses = true
    selector = {
      name = "agentenv-node"
    }

    ports {
      name        = "http"
      port        = 8000
      target_port = 8000
    }
  }
}

# ----------------------------------------------------------------------------
# Scheduler — routes requests to runtime nodes via round-robin (single replica)
# ----------------------------------------------------------------------------

module "agentenv_scheduler" {
  source    = "../../modules/generic-deployment-service"
  name      = "agentenv-scheduler"
  namespace = module.namespace.name
  image     = var.scheduler_image
  replicas  = 1

  ports_map = { grpc = 9090 }

  args = ["-config", "/config/scheduler.json"]

  configmap            = module.scheduler_config.config_map
  configmap_mount_path = "/config"

  # The scheduler discovers nodes by watching EndpointSlices + pods.
  role_rules = [
    {
      api_groups = ["discovery.k8s.io"]
      resources  = ["endpointslices"]
      verbs      = ["get", "list", "watch"]
    },
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["get", "list", "watch"]
    },
  ]

  readiness_probe = {
    exec = {
      command = ["/grpc_health_probe", "-addr=127.0.0.1:9090"]
    }
    initial_delay_seconds = 3
    period_seconds        = 10
  }

  liveness_probe = {
    exec = {
      command = ["/grpc_health_probe", "-addr=127.0.0.1:9090"]
    }
    initial_delay_seconds = 10
    period_seconds        = 20
  }
}

# ----------------------------------------------------------------------------
# Gateway — HTTP entrypoint, forwards to the scheduler
# ----------------------------------------------------------------------------

module "agentenv_gateway" {
  source    = "../../modules/generic-deployment-service"
  name      = "agentenv-gateway"
  namespace = module.namespace.name
  image     = var.gateway_image
  replicas  = 1

  ports_map = { http = 8080 }

  args = ["-config", "/config/gateway.json"]

  env_map = {
    GATEWAY_SANDBOX_PROXY_DOMAINS = var.sandbox_proxy_domains
  }

  configmap            = module.gateway_config.config_map
  configmap_mount_path = "/config"

  readiness_probe = {
    http_get              = { path = "/health", port = 8080 }
    initial_delay_seconds = 3
    period_seconds        = 10
  }

  liveness_probe = {
    http_get              = { path = "/health", port = 8080 }
    initial_delay_seconds = 10
    period_seconds        = 20
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"          = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"          = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
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
              name = module.agentenv_gateway.name
              port {
                number = module.agentenv_gateway.ports_map.http
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
