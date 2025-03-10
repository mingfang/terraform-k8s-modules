
# Module `kubernetes/dashboard-metrics-scraper`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `image` (default `"kubernetesui/metrics-scraper:v1.0.6"`)
* `name` (default `"dashboard-metrics-scraper"`): do not change
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000}]`): do not change
* `replicas` (default `1`)
* `resources` (default `{}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`
* `service_account`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

