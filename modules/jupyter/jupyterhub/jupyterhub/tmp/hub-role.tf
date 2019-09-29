resource "k8s_rbac_authorization_k8s_io_v1_role" "hub" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "hub"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "hub"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "pods",
      "persistentvolumeclaims",
    ]
    verbs = [
      "get",
      "watch",
      "list",
      "create",
      "delete",
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
      "get",
      "watch",
      "list",
    ]
  }
}