
# Module `kubernetes/dashboard`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `""`)
* `env` (default `[]`)
* `image` (default `"kubernetesui/dashboard:v2.7.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9090}]`)
* `replicas` (default `1`)
* `resources` (default `{}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`
* `service_account`

## Managed Resources
* `k8s_core_v1_secret.kubernetes-dashboard-key-holder` from `k8s`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `kubernetes-dashboard-certs` from [../../../modules/kubernetes/secret](../../../modules/kubernetes/secret)
* `kubernetes-dashboard-csrf` from [../../../modules/kubernetes/secret](../../../modules/kubernetes/secret)
* `kubernetes-dashboard-settings` from [../../../modules/kubernetes/config-map](../../../modules/kubernetes/config-map)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

