resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "kiali" {
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "kiali"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
      "endpoints",
      "namespaces",
      "nodes",
      "pods",
      "pods/log",
      "replicationcontrollers",
      "services",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
      "apps",
    ]
    resources = [
      "deployments",
      "replicasets",
      "statefulsets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "autoscaling",
    ]
    resources = [
      "horizontalpodautoscalers",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "batch",
    ]
    resources = [
      "cronjobs",
      "jobs",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "config.istio.io",
      "networking.istio.io",
      "authentication.istio.io",
      "rbac.istio.io",
      "security.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "create",
      "delete",
      "get",
      "list",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "monitoring.kiali.io",
    ]
    resources = [
      "monitoringdashboards",
    ]
    verbs = [
      "get",
      "list",
    ]
  }
}