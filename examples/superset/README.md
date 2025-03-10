
# Module `superset`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"superset"`)
* `namespace` (default `"superset-example"`)
* `replicas` (default `1`)
* `storage_class_name` (default `"cephfs-csi"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.superset` from `k8s`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `datasources` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `env` from [../../modules/kubernetes/env](../../modules/kubernetes/env)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `redis` from [../../modules/redis](../../modules/redis)
* `superset` from [../../modules/superset](../../modules/superset)
* `superset-beat` from [../../modules/superset/celery](../../modules/superset/celery)
* `superset-worker` from [../../modules/superset/celery](../../modules/superset/celery)

