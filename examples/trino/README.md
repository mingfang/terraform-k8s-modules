
# Module `trino`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"trino"`)
* `namespace` (default `"trino-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.trino` from `k8s`

## Child Modules
* `ferretdb` from [../../modules/ferretdb](../../modules/ferretdb)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `trino` from [../../modules/trino](../../modules/trino)
* `trino-catalog` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `trino-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `trino-worker` from [../../modules/trino](../../modules/trino)
* `trino-worker-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)

