
# Module `zalenium`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CONTEXT_PATH` (default `null`)
* `DEBUG_ENABLED` (default `"false"`)
* `DESIRED_CONTAINERS` (default `1`)
* `KEEP_ONLY_FAILED_TESTS` (default `null`)
* `MAX_DOCKER_SELENIUM_CONTAINERS` (default `10`)
* `MAX_TEST_SESSIONS` (default `1`)
* `NEW_SESSION_WAIT_TIMEOUT` (default `"600000"`)
* `NGINX_MAX_BODY_SIZE` (default `null`)
* `RETENTION_PERIOD` (default `null`)
* `SCREEN_HEIGHT` (default `"900"`)
* `SCREEN_WIDTH` (default `"1440"`)
* `SELENIUM_IMAGE_NAME` (default `"elgalu/selenium"`)
* `SEND_ANONYMOUS_USAGE_INFO` (default `"true"`)
* `TIME_TO_WAIT_TO_START` (default `null`)
* `TZ` (default `null`)
* `VIDEO_RECORDING_ENABLED` (default `"true"`)
* `ZALENIUM_KUBERNETES_CPU_LIMIT` (default `"1000m"`)
* `ZALENIUM_KUBERNETES_CPU_REQUEST` (default `"250m"`)
* `ZALENIUM_KUBERNETES_MEMORY_LIMIT` (default `"2Gi"`)
* `ZALENIUM_KUBERNETES_MEMORY_REQUEST` (default `"500Mi"`)
* `ZALENIUM_KUBERNETES_NODE_SELECTOR` (default `null`)
* `ZALENIUM_KUBERNETES_TOLERATIONS` (default `null`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"dosel/zalenium"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"webdriver","port":4444}]`)
* `pvc_name` (default `null`)
* `replicas` (default `1`)
* `user_secret_name` (default `null`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)
* `rbac` from [../kubernetes/rbac](../kubernetes/rbac)

