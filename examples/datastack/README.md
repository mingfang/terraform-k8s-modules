
# Module `datastack`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `"IUWU60H2527LP7DOYJVP"`)
* `minio_secret_key` (default `"bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"`)
* `name` (default `"datastack"`)
* `namespace` (default `"datastack-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.connect-data` from `k8s`
* `k8s_core_v1_persistent_volume_claim.materialized` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.kowl` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.minio` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.redpanda` from `k8s`

## Child Modules
* `connect` from [../../modules/confluentinc/connect](../../modules/confluentinc/connect)
* `connect-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `kowl` from [../../modules/kowl](../../modules/kowl)
* `kowl_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `materialized` from [../../modules/materialized](../../modules/materialized)
* `minio` from [../../modules/minio](../../modules/minio)
* `redpanda` from [../../modules/redpanda](../../modules/redpanda)

