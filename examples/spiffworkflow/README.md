
# Module `spiffworkflow`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"spiffworkflow"`)
* `namespace` (default `"spiffworkflow-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `spiffworkflow-backend` from [../../modules/spiffworkflow/backend](../../modules/spiffworkflow/backend)
* `spiffworkflow-frontend` from [../../modules/spiffworkflow/frontend](../../modules/spiffworkflow/frontend)
* `spiffworkflow-permissions` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)

