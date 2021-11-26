
# Module `sentry/worker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env_config_map` (default `{}`): Name of ConfigMap with environment variables
* `etc_config_map` (default `null`): Name of ConfigMap with /etc/sentry files
* `image` (default `"getsentry/sentry:c6fa004"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

