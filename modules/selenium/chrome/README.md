
# Module `selenium/chrome`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `HUB_HOST` (required)
* `HUB_PORT` (default `4444`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"selenium/node-chrome-debug:3.141"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"vnc","port":5900}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

