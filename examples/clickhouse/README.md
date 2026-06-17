
# Module `clickhouse`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"clickhouse"`)
* `namespace` (default `"clickhouse-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `clickhouse` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `clickhouse_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `clickhouse_keeper` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `clickhouse_keeper_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `namespace` from [../namespace](../namespace)

