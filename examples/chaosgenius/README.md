
# Module `chaosgenius`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"chaosgenius"`)
* `namespace` (default `"chaosgenius-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.pgadmin` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.chaosgenius` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.pgadmin` from `k8s`

## Child Modules
* `chaosgenius-scheduler` from [../../modules/chaosgenius/chaosgenius-scheduler](../../modules/chaosgenius/chaosgenius-scheduler)
* `chaosgenius-server` from [../../modules/chaosgenius/chaosgenius-server](../../modules/chaosgenius/chaosgenius-server)
* `chaosgenius-webapp` from [../../modules/chaosgenius/chaosgenius-webapp](../../modules/chaosgenius/chaosgenius-webapp)
* `chaosgenius-worker-alerts` from [../../modules/chaosgenius/chaosgenius-worker-alerts](../../modules/chaosgenius/chaosgenius-worker-alerts)
* `chaosgenius-worker-analytics` from [../../modules/chaosgenius/chaosgenius-worker-analytics](../../modules/chaosgenius/chaosgenius-worker-analytics)
* `env` from [../../modules/kubernetes/env](../../modules/kubernetes/env)
* `pgadmin` from [../../modules/pgadmin](../../modules/pgadmin)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `redis` from [../../modules/redis](../../modules/redis)

