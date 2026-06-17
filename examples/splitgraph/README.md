
# Module `splitgraph`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `""YOUR_ACCESS_KEY""`)
* `minio_secret_key` (default `""YOUR_SECRET_KEY""`)
* `name` (default `"splitgraph"`)
* `namespace` (default `"splitgraph-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.pgadmin` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.minio` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.minio-console` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.pgadmin` from `k8s`

## Child Modules
* `minio` from [../../modules/minio](../../modules/minio)
* `pgadmin` from [../../modules/pgadmin](../../modules/pgadmin)
* `sgconfig` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `splitgraph` from [../../modules/splitgraph](../../modules/splitgraph)

