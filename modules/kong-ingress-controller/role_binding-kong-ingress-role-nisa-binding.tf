"resource" "k8s_rbac_authorization_k8s_io_v1_role_binding" "kong-ingress-role-nisa-binding" {
  "metadata" = [
    {
      "name" = "kong-ingress-role-nisa-binding"

      "namespace" = "kong"
    },
  ]

  "role_ref" = [
    {
      "api_group" = "rbac.authorization.k8s.io"

      "kind" = "Role"

      "name" = "kong-ingress-role"
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
