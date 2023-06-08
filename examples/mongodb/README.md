
# Module `mongodb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **random:** (any version)

## Input Variables
* `name` (default `"mongodb"`)
* `namespace` (default `"mongodb-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.meilisearch` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.mongo-express` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.trino` from `k8s`
* `random_password.keyfile` from `random`

## Child Modules
* `meilisearch` from [../../modules/meilisearch](../../modules/meilisearch)
* `mongo-express` from [../../modules/mongo-express](../../modules/mongo-express)
* `mongodb` from [../../modules/mongodb](../../modules/mongodb)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `trino` from [../../modules/trino](../../modules/trino)
* `trino-catalog` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `trino-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `trino-worker` from [../../modules/trino](../../modules/trino)
* `trino-worker-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)

