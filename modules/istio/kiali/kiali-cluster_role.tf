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
      "services",
      "replicationcontrollers",
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
      "statefulsets",
      "replicasets",
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
    ]
    resources = [
      "apikeys",
      "authorizations",
      "checknothings",
      "circonuses",
      "deniers",
      "fluentds",
      "handlers",
      "kubernetesenvs",
      "kuberneteses",
      "listcheckers",
      "listentries",
      "logentries",
      "memquotas",
      "metrics",
      "opas",
      "prometheuses",
      "quotas",
      "quotaspecbindings",
      "quotaspecs",
      "rbacs",
      "reportnothings",
      "rules",
      "solarwindses",
      "stackdrivers",
      "statsds",
      "stdios",
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
      "networking.istio.io",
    ]
    resources = [
      "destinationrules",
      "gateways",
      "serviceentries",
      "virtualservices",
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
      "authentication.istio.io",
    ]
    resources = [
      "policies",
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
}