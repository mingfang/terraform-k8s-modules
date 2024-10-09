
# Module `postgrest`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"postgrest"`)
* `namespace` (default `"postgrest-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.postgrest` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.postgrest_admin` from `k8s`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postgres_init` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `postgres_init_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `postgrest` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `swagger-ui` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

