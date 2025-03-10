
# Module `keycloak`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"keycloak"`)
* `namespace` (default `"keycloak-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.keycloak` from `k8s`

## Child Modules
* `keycloak` from [../../modules/keycloak](../../modules/keycloak)
* `postgres` from [../../modules/postgres](../../modules/postgres)

