resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "istio-security-post-install-istio-system" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-security-post-install-istio-system"
  }

  rules {
    api_groups = [
      "authentication.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "networking.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "*",
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
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}