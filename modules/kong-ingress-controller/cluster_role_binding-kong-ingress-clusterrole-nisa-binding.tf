"resource" "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "kong-ingress-clusterrole-nisa-binding" {
  "metadata" = [
    {
      "name" = "kong-ingress-clusterrole-nisa-binding"
    },
  ]

  "role_ref" = [
    {
      "api_group" = "rbac.authorization.k8s.io"

      "kind" = "ClusterRole"

      "name" = "kong-ingress-clusterrole"
    },
  ]

  "subjects" = [
    {
      "kind" = "ServiceAccount"

      "name" = "kong-serviceaccount"

      "namespace" = "kong"
    },
  ]
}
