
# Module `stackstorm/st2web`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ST2_API_URL` (required)
* `ST2_AUTH_URL` (required)
* `ST2_STREAM_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2web:3.6.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

