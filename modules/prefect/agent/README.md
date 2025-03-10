
# Module `prefect/agent`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `IMAGE_PULL_POLICY` (default `""`)
* `IMAGE_PULL_SECRETS` (default `""`)
* `JOB_CPU_LIMIT` (default `""`)
* `JOB_CPU_REQUEST` (default `""`)
* `JOB_MEM_LIMIT` (default `""`)
* `JOB_MEM_REQUEST` (default `""`)
* `JOB_NAMESPACE` (default `""`)
* `PREFECT__BACKEND` (default `"server"`): server or cloud
* `PREFECT__CLOUD__AGENT__AGENT_ADDRESS` (default `"http://:8080"`)
* `PREFECT__CLOUD__AGENT__AUTH_TOKEN` (default `""`): only needed for cloud
* `PREFECT__CLOUD__AGENT__LABELS` (default `"[]"`)
* `PREFECT__CLOUD__API` (required): http://prefect-apollo:4200
* `SERVICE_ACCOUNT_NAME` (default `""`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"prefecthq/prefect:all_extras-0.12.6"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"cpu":"100m","memory":"128Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

