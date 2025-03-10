
# Module `eve`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `MONGO_URI` (required): mongodb://root:example@mongo:27017/
* `annotations` (default `{}`)
* `domain_config` (default `null`): configmap with domain.json key
* `env` (default `[]`)
* `image` (default `"mingfang/eve:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":5000}]`)
* `replicas` (default `1`)
* `resources` (default `{}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

