
# Module `airflow/webserver`

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
* `ports` (default `[{"name":"http","port":8080}]`)
* `pvc_dags` (default `null`)
* `pvc_logs` (default `null`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

