
# Module `vault-k8s`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"vault-k8s"`)
* `namespace` (default `"vault-k8s-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.nginx` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding.this` from `k8s`

## Child Modules
* `nginx` from [../../modules/nginx](../../modules/nginx)
* `vault-k8s` from [../../modules/vault-k8s](../../modules/vault-k8s)

