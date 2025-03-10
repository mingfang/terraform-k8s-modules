
# Module `nuclio/dashboard`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `NUCLIO_BUSYBOX_CONTAINER_IMAGE` (default `"busybox:1.31"`)
* `NUCLIO_CONTAINER_BUILDER_KIND` (default `"kaniko"`)
* `NUCLIO_DASHBOARD_IMAGE_NAME_PREFIX_TEMPLATE` (default `"function-"`): prefix function image names
* `NUCLIO_DASHBOARD_REGISTRY_URL` (required): used for pushing(build time)
* `NUCLIO_DASHBOARD_RUN_REGISTRY_URL` (required): used for pulling(run time)
* `NUCLIO_KANIKO_CONTAINER_IMAGE` (default `"gcr.io/kaniko-project/executor:v1.8.1"`)
* `NUCLIO_KANIKO_INSECURE_PUSH_REGISTRY` (default `"false"`)
* `NUCLIO_KANIKO_JOB_DELETION_TIMEOUT` (default `"30m"`)
* `NUCLIO_KANIKO_PUSH_IMAGES_RETRIES` (default `"3"`)
* `NUCLIO_MONITOR_DOCKER_DAEMON` (default `"true"`)
* `NUCLIO_MONITOR_DOCKER_DAEMON_INTERVAL` (default `"5s"`)
* `NUCLIO_MONITOR_DOCKER_DAEMON_MAX_CONSECUTIVE_ERRORS` (default `"5"`)
* `annotations` (default `{}`)
* `configmap` (default `null`)
* `env` (default `[]`)
* `image` (default `"quay.io/nuclio/dashboard:1.1.11-amd64"`)
* `name` (default `"dashboard"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":8070}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

