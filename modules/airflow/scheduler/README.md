
# Module `airflow/scheduler`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AIRFLOW__CORE__SQL_ALCHEMY_CONN` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"apache/airflow:1.10.10-python3.6"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `pvc_dags` (default `null`)
* `pvc_logs` (default `null`)

## Output Values
* `deployment`
* `name`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

