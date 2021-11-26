
# Module `kubernetes/dashboard-metrics-scraper`

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

