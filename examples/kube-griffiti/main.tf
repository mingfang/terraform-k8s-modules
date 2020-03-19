resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_cert_manager_io_v1alpha2_certificate" "this" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    secret_name = var.name
    common_name = var.name
    isca        = true
    issuer_ref {
      kind = "ClusterIssuer"
      name = "test-selfsigned"
    }
  }
}

module "kube-griffiti" {
  source    = "../../modules/kubernetes/kube-griffiti"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  secret_name    = var.name
  log_level      = "debug"
  check_existing = true

  rules = <<-EOF
    - registration:
        name: che-workspaces
        targets:
        - api-groups:
          - ""
          api-versions:
          - v1
          resources:
          - namespaces
        failure-policy: Ignore
      matchers:
        field-selectors:
        - metadata.name=legionx-mingfang
      payload:
        additions:
          annotations:
          - scheduler.alpha.kubernetes.io/node-selector: "host=ripper2"
    EOF

  rbac_cluster_role_rules = [
    {
      api_groups = [
        "",
      ]

      api-versions = [
        "v1"
      ]

      resources = [
        "namespaces",
      ]

      // these verbs are almost always needed
      verbs = [
        "get",
        "list",
        "patch",
        "watch",
      ]
    },
  ]
}