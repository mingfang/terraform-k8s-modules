
# Module `openfaas/faas-netes`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `function_namespace` (default `null`): default to same namespace as gateway
* `http_probe` (default `true`)
* `image` (default `"ghcr.io/openfaas/faas-netes:0.14.2"`)
* `image_pull_policy` (default `"Always"`)
* `liveness_probe_initial_delay_seconds` (default `2`)
* `liveness_probe_period_seconds` (default `2`)
* `liveness_probe_timeout_seconds` (default `1`)
* `name` (required)
* `namespace` (required)
* `operator` (default `false`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `read_timeout` (default `"60s"`)
* `readiness_probe_initial_delay_seconds` (default `2`)
* `readiness_probe_period_seconds` (default `2`)
* `readiness_probe_timeout_seconds` (default `1`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"50m","memory":"120Mi"}}`)
* `set_nonroot_user` (default `false`)
* `write_timeout` (default `"60s"`)

## Output Values
* `deployment`
* `name`
* `service`
* `service_account_name`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

