
# Module `neon`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AWS_ACCESS_KEY` (required)
* `AWS_SECRET_ACCESS_KEY` (required)
* `name` (default `"neon"`)
* `namespace` (default `"neon-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.wsproxy` from `k8s`

## Child Modules
* `compute` from [../../modules/neon/compute](../../modules/neon/compute)
* `compute_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `pageserver` from [../../modules/neon/pageserver](../../modules/neon/pageserver)
* `postgres_init` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `postgres_init_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `safekeeper` from [../../modules/neon/safekeeper](../../modules/neon/safekeeper)
* `secrets` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `storage_broker` from [../../modules/neon/storage-broker](../../modules/neon/storage-broker)
* `wsproxy` from [../../modules/neon/wsproxy](../../modules/neon/wsproxy)

