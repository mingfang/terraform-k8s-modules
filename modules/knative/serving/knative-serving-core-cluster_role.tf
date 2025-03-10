resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "knative-serving-core" {
  metadata {
    labels = {
      "serving.knative.dev/controller" = "true"
      "serving.knative.dev/release"    = "devel"
    }
    name = "knative-serving-core"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "pods",
      "namespaces",
      "secrets",
      "configmaps",
      "endpoints",
      "services",
      "events",
      "serviceaccounts",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
    ]
    resources = [
      "ingresses",
      "deployments",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "apps",
    ]
    resources = [
      "deployments",
      "deployments/scale",
      "statefulsets",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "admissionregistration.k8s.io",
    ]
    resources = [
      "mutatingwebhookconfigurations",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "apiextensions.k8s.io",
    ]
    resources = [
      "customresourcedefinitions",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "serving.knative.dev",
    ]
    resources = [
      "configurations",
      "routes",
      "revisions",
      "services",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "serving.knative.dev",
    ]
    resources = [
      "configurations/status",
      "routes/status",
      "revisions/status",
      "services/status",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "autoscaling.internal.knative.dev",
    ]
    resources = [
      "podautoscalers",
      "podautoscalers/status",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
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
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "caching.internal.knative.dev",
    ]
    resources = [
      "images",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "patch",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "networking.internal.knative.dev",
    ]
    resources = [
      "clusteringresses",
      "clusteringresses/status",
      "serverlessservices",
      "serverlessservices/status",
    ]
    verbs = [
      "get",
      "list",
      "create",
      "update",
      "delete",
      "deletecollection",
      "patch",
      "watch",
    ]
  }
}