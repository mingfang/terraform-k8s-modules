
# Module `nuclio/controller`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `NUCLIO_CONTROLLER_API_GATEWAY_OPERATOR_NUM_WORKERS` (default `"2"`)
* `NUCLIO_CONTROLLER_CRON_TRIGGER_CRON_JOB_IMAGE_NAME` (default `"appropriate/curl:latest"`)
* `NUCLIO_CONTROLLER_FUNCTION_EVENT_OPERATOR_NUM_WORKERS` (default `"2"`)
* `NUCLIO_CONTROLLER_FUNCTION_MONITOR_INTERVAL` (default `"3m"`)
* `NUCLIO_CONTROLLER_FUNCTION_OPERATOR_NUM_WORKERS` (default `"4"`)
* `NUCLIO_CONTROLLER_PROJECT_OPERATOR_NUM_WORKERS` (default `"2"`)
* `NUCLIO_CONTROLLER_RESYNC_INTERVAL` (default `"0"`)
* `annotations` (default `{}`)
* `configmap` (default `null`)
* `env` (default `[]`)
* `image` (default `"quay.io/nuclio/controller:1.1.11-amd64"`)
* `name` (default `"controller"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`
* `service_account`

## Managed Resources
* `k8s_apiextensions_k8s_io_v1_custom_resource_definition.nuclioapigateways` from `k8s`
* `k8s_apiextensions_k8s_io_v1_custom_resource_definition.nucliofunctionevents` from `k8s`
* `k8s_apiextensions_k8s_io_v1_custom_resource_definition.nucliofunctions` from `k8s`
* `k8s_apiextensions_k8s_io_v1_custom_resource_definition.nuclioprojects` from `k8s`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../kubernetes/rbac](../../kubernetes/rbac)

