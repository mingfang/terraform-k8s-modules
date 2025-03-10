
# Module `jenkins/jenkins`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `casc_config_map_name` (required)
* `env` (default `[]`)
* `image` (default `"mingfang/jenkins:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080},{"name":"slave","port":50000}]`)
* `pvc_name` (required)
* `resources` (default `{"limits":{"memory":"1Gi"},"requests":{"cpu":"500m","memory":"500Mi"}}`)
* `timezone` (default `"America/New_York"`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

