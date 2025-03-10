
# Module `zeebe/simple-monitor`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ZEEBE_CLIENT_BROKER_CONTACTPOINT` (required)
* `ZEEBE_CLIENT_SECURITY_PLAINTEXT` (default `true`)
* `ZEEBE_CLIENT_WORKER_HAZELCAST_CONNECTION` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"camunda/zeebe-simple-monitor:0.19.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8082}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

