
# Module `superset`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"prefect"`)
* `namespace` (default `"prefect-example"`)
* `replicas` (default `1`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.hasura` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.prefect` from `k8s`

## Child Modules
* `hasura` from [../../modules/hasura/graphql-engine](../../modules/hasura/graphql-engine)
* `nginx` from [../../modules/nginx](../../modules/nginx)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `prefect-agent` from [../../modules/prefect/agent](../../modules/prefect/agent)
* `prefect-apollo` from [../../modules/prefect/apollo](../../modules/prefect/apollo)
* `prefect-scheduler` from [../../modules/prefect/scheduler](../../modules/prefect/scheduler)
* `prefect-server` from [../../modules/prefect/server](../../modules/prefect/server)
* `prefect-ui` from [../../modules/prefect/ui](../../modules/prefect/ui)

