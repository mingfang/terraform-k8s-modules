/*
For reference of similar setup

Part 1
https://blog.zabbix.com/monitoring-kubernetes-with-zabbix/25055/

Part 2
https://blog.zabbix.com/kubernetes-monitoring-with-zabbix-part-2-understanding-the-discovered-resources/25476/

Part 3, optional for applications
https://blog.zabbix.com/kubernetes-monitoring-with-zabbix-part-3-extracting-prometheus-metrics-with-zabbix-preprocessing/25639/

Required Macros:

Kubernetes Nodes
  {$KUBE.API.TOKEN} = <kubectl get secret zabbix-proxy -n zabbix-example -o jsonpath={.data.token} | base64 -d>
  {$KUBE.API.URL} = https://kubernetes.default.svc.cluster.local:443
  {$KUBE.NODES.ENDPOINT.NAME} = zabbix-agent

Kubernetes Cluster State
  {$KUBE.API.TOKEN} = <kubectl get secret zabbix-proxy -n zabbix-example -o jsonpath={.data.token} | base64 -d>
  {$KUBE.CONTROL_PLANE.TAINT} = depending on your cluster, e.g. node.kubernetes.io/master
  {$KUBE.STATE.ENDPOINT.NAME} = kube-state-metrics
*/

resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "kube-state-metrics" {
  source    = "../../modules/generic-statefulset-service"
  name      = "kube-state-metrics"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  image     = "registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.14.0"
  replicas  = 2
  ports = [
    {
      name = "metrics"
      port = 8080
    }
  ]
  args = [
    "--pod=$(POD_NAME)",
    "--pod-namespace=$(POD_NAMESPACE)",
  ]

  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["configmaps", "secrets", "nodes", "pods", "services", "serviceaccounts", "resourcequotas", "replicationcontrollers", "limitranges", "persistentvolumeclaims", "persistentvolumes", "namespaces", "endpoints"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["apps"]
      resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["batch"]
      resources  = ["cronjobs", "jobs"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["autoscaling"]
      resources  = ["horizontalpodautoscalers"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["authentication.k8s.io"]
      resources  = ["tokenreviews"]
      verbs      = ["create"]
    },
    {
      api_groups = ["authentication.k8s.io"]
      resources  = ["subjectaccessreviews"]
      verbs      = ["create"]
    },
    {
      api_groups = ["policy"]
      resources  = ["poddisruptionbudgets"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["certificates.k8s.io"]
      resources  = ["certificatesigningrequests"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["discovery.k8s.io"]
      resources  = ["endpointslices"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["storage.k8s.io"]
      resources  = ["storageclasses", "volumeattachments"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["admissionregistration.k8s.io"]
      resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["networking.k8s.io"]
      resources  = ["networkpolicies", "ingressclasses", "ingresses"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["coordination.k8s.io"]
      resources  = ["leases"]
      verbs      = ["list", "watch"]
    },
    {
      api_groups = ["rbac.authorization.k8s.io"]
      resources  = ["clusterrolebindings", "clusterroles", "rolebindings", "roles"]
      verbs      = ["list", "watch"]
    },
  ]

  role_rules = [
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["get"]
    },
    {
      api_groups    = ["apps"]
      resource_name = ["kube-state-metrics"]
      resources     = ["statefulsets"]
      verbs         = ["get"]
    },
  ]
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image = "postgres:16"

  args = [
    "-c", "work_mem=512MB",
    "-c", "maintenance_work_mem=512MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
    "-c", "log_statement=all",
    "-c", "max_worker_processes=128",
  ]

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }

  storage       = "1Gi"
  storage_class = "cephfs-csi"
}

module "zabbix-server" {
  source    = "../../modules/generic-deployment-service"
  name      = "zabbix-server"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  image     = "zabbix/zabbix-server-pgsql:latest"
  ports     = [{ name = "tcp", port = 10051 }]

  sidecars = [
    {
      name  = "zabbix-agent"
      image = "zabbix/zabbix-agent2:latest"

      env = [
        { name = "ZBX_HOSTNAME", value = "Zabbix server" },
        { name = "ZBX_SERVER_HOST", value = "127.0.0.1" },
        { name = "ZBX_SERVER_PORT", value = "10051" },
      ]
    }
  ]

  env_map = {
    DB_SERVER_HOST    = module.postgres.name
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "zabbix-proxy" {
  source    = "../../modules/generic-deployment-service"
  name      = "zabbix-proxy"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  image     = "zabbix/zabbix-proxy-sqlite3:latest"
  ports     = [{ name = "tcp", port = 10051 }]

  env_map = {
    ZBX_HOSTNAME        = "zabbix-proxy"
    ZBX_SERVER_HOST     = module.zabbix-server.name
    ZBX_SERVER_PORT     = module.zabbix-server.ports.0.port
    ZBX_PROXYMODE       = "0"
    ZBX_CACHESIZE       = "256M"
    ZBX_VALUECACHESIZE  = "128M"
    ZBX_CONFIGFREQUENCY = "60"
  }

  cluster_role_rules = [
    {
      non_resource_urls = ["/metrics", "/metrics/cadvisor", "/version", "/healthz", "/readyz"]
      verbs             = ["get"]
    },
    {
      api_groups = [""]
      resources  = ["nodes/metrics", "nodes/spec", "nodes/proxy", "nodes/stats"]
      verbs      = ["get"]
    },
    {
      api_groups = [""]
      resources  = ["namespaces", "pods", "services", "componentstatuses", "nodes", "endpoints", "events"]
      verbs      = ["get", "list"]
    },
    {
      api_groups = ["batch"]
      resources  = ["jobs", "cronjobs"]
      verbs      = ["get", "list"]
    },
    {
      api_groups = ["extensions"]
      resources  = ["deployments", "daemonsets"]
      verbs      = ["get", "list"]
    },
    {
      api_groups = ["apps"]
      resources  = ["statefulsets", "deployments", "daemonsets"]
      verbs      = ["get", "list"]
    },
  ]
}

module "zabbix-agent" {
  source    = "../../modules/generic-daemonset"
  name      = "zabbix-agent"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  image     = "zabbix/zabbix-agent2:latest"

  env_map = {
    ZBX_SERVER_HOST    = module.zabbix-proxy.name
    ZBX_PASSIVESERVERS = "0.0.0.0/0"
  }

  /* enables kube-dns with host network */
  dns_policy   = "None"
  dns_config = {
    nameservers = ["172.27.0.2"]
    searches    = ["${var.namespace}.svc.cluster.local", "svc.cluster.local", "cluster.local"]
  }
  host_network = "true"
  host_pid = true

  tolerations = [
    {
      effect = "NoSchedule"
      key    = "CriticalAddonsOnly"
    },
    {
      effect = "NoSchedule"
      key    = "node.kubernetes.io/master"
    }
  ]

  volumes = [
    {
      name = "proc"
      host_path = {
        path = "/proc"
      }
      mount_path = "/hostfs/proc"
      read_only = true
    },
    {
      name = "sys"
      host_path = {
        path = "/sys"
      }
      mount_path = "/hostfs/sys"
      read_only = true
    },
    {
      name = "root"
      host_path = {
        path = "/"
      }
      mount_path = "/hostfs/root"
      read_only = true
    }
  ]
}

/*
normally daemonsets don't need services but this is need for discovery via the endpoints
set {$KUBE.NODES.ENDPOINT.NAME} = zabbix-agent
*/
resource "k8s_core_v1_service" "zabbix-agent" {
  metadata {
    name      = "zabbix-agent"
    namespace = k8s_core_v1_namespace.this.metadata.0.name
    labels    = module.zabbix-agent.daemonset.metadata[0].labels
  }
  spec {
    type = "ClusterIP"
    ports {
      port = 10050
    }
    selector = module.zabbix-agent.daemonset.metadata[0].labels
  }
}

module "zabbix-web" {
  source    = "../../modules/generic-deployment-service"
  name      = "zabbix-web"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  image     = "zabbix/zabbix-web-nginx-pgsql:latest"
  ports     = [{ name = "tcp", port = 8080 }]

  env_map = {
    DB_SERVER_HOST    = module.postgres.name
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
    ZBX_SERVER_HOST   = module.zabbix-server.name
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "zabbix" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.zabbix-web.name
              port {
                number = module.zabbix-web.ports.0.port
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
