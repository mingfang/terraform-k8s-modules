
# Module `sonarqube`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `SONAR_JDBC_PASSWORD` (required)
* `SONAR_JDBC_URL` (required)
* `SONAR_JDBC_USERNAME` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"sonarqube:8.4-community"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9000}]`)
* `replicas` (default `1`)
* `sonarqube_data_pvc_name` (required)
* `sonarqube_extensions_pvc_name` (required)
* `sonarqube_logs_pvc_name` (required)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

