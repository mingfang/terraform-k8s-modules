
# Module `airflow`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"airflow"`)
* `namespace` (default `"airflow-example"`)
* `replicas` (default `1`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.dag` from `k8s`
* `k8s_core_v1_persistent_volume_claim.logs` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.airflow` from `k8s`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `scheduler` from [../../modules/airflow/scheduler](../../modules/airflow/scheduler)
* `webserver` from [../../modules/airflow/webserver](../../modules/airflow/webserver)

