resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "keda_operator" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = "keda-operator"
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "keda-operator"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
      "configmaps/status",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "events",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "external",
      "pods",
      "secrets",
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
      "",
    ]
    resources = [
      "limitranges",
    ]
    verbs = [
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "serviceaccounts",
    ]
    verbs = [
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "*",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "get",
    ]
  }
  rules {
    api_groups = [
      "*",
    ]
    resources = [
      "*/scale",
    ]
    verbs = [
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "admissionregistration.k8s.io",
    ]
    resources = [
      "validatingwebhookconfigurations",
    ]
    verbs = [
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "apiregistration.k8s.io",
    ]
    resources = [
      "apiservices",
    ]
    verbs = [
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "apps",
    ]
    resources = [
      "deployments",
      "statefulsets",
    ]
    verbs = [
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
      "*",
    ]
  }
  rules {
    api_groups = [
      "batch",
    ]
    resources = [
      "jobs",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "eventing.keda.sh",
    ]
    resources = [
      "cloudeventsources",
      "cloudeventsources/status",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "keda.sh",
    ]
    resources = [
      "clustertriggerauthentications",
      "clustertriggerauthentications/status",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "keda.sh",
    ]
    resources = [
      "scaledjobs",
      "scaledjobs/finalizers",
      "scaledjobs/status",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "keda.sh",
    ]
    resources = [
      "scaledobjects",
      "scaledobjects/finalizers",
      "scaledobjects/status",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "keda.sh",
    ]
    resources = [
      "triggerauthentications",
      "triggerauthentications/status",
    ]
    verbs = [
      "*",
    ]
  }
}