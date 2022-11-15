
# Module `dagster`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"dagster"`)
* `namespace` (default `"dagster-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.dagit` from `k8s`

## Child Modules
* `config_map_dagster` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config_map_job` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config_map_job_env` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config_map_workspace` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `dagit` from [../../modules/dagster/dagit](../../modules/dagster/dagit)
* `dagster-daemon` from [../../modules/dagster/dagster-daemon](../../modules/dagster/dagster-daemon)
* `dagster-dbt` from [../../modules/dagster/user-repository](../../modules/dagster/user-repository)
* `example-user-code` from [../../modules/dagster/user-repository](../../modules/dagster/user-repository)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postgres_password` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

