
# Module `archetypes/deployment-service`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `parameters` (default `null`)
* `podAnnotations` (default `{}`)

## Output Values
* `deployment`
* `labels`
* `name`
* `service`

## Managed Resources
* `k8s_apps_v1_deployment.this` from `k8s`
* `k8s_core_v1_service.this` from `k8s`

