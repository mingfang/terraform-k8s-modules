
# Module `zeebe/script-worker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ZEEBE_CLIENT_BROKER_CONTACTPOINT` (default `"127.0.0.1:26500"`)
* `ZEEBE_CLIENT_SECURITY_PLAINTEXT` (default `true`)
* `ZEEBE_WORKER_DEFAULTNAME` (default `"script-worker"`)
* `ZEEBE_WORKER_DEFAULTTYPE` (default `"script"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"ghcr.io/camunda-community-hub/zeebe-script-worker:1.0.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

