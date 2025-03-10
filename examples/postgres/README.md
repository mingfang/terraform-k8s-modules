
# Module `postgres`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"postgres"`)
* `namespace` (default `"postgres-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.s3` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.featureserv` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.martin` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.tileserv` from `k8s`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `featureserv` from [../../modules/pg_featureserv](../../modules/pg_featureserv)
* `init_job` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `martin` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `tileserv` from [../../modules/pg_tileserv](../../modules/pg_tileserv)

