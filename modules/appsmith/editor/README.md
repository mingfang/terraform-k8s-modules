
# Module `appsmith/editor`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `APPSMITH_ALGOLIA_API_ID` (default `""`)
* `APPSMITH_ALGOLIA_API_KEY` (default `""`)
* `APPSMITH_ALGOLIA_SEARCH_INDEX_NAME` (default `""`)
* `APPSMITH_CLIENT_LOG_LEVEL` (default `""`)
* `APPSMITH_DISABLE_TELEMETRY` (default `""`)
* `APPSMITH_GOOGLE_MAPS_API_KEY` (default `""`)
* `APPSMITH_INTERCOM_APP_ID` (default `""`)
* `APPSMITH_MAIL_ENABLED` (default `""`)
* `APPSMITH_MARKETPLACE_ENABLED` (default `""`)
* `APPSMITH_OAUTH2_GITHUB_CLIENT_ID` (default `""`)
* `APPSMITH_OAUTH2_GOOGLE_CLIENT_ID` (default `""`)
* `APPSMITH_OPTIMIZELY_KEY` (default `""`)
* `APPSMITH_SEGMENT_KEY` (default `""`)
* `APPSMITH_SENTRY_DSN` (default `""`)
* `APPSMITH_SMART_LOOK_ID` (default `""`)
* `APPSMITH_TNC_PP` (default `""`)
* `APPSMITH_VERSION_ID` (default `""`)
* `APPSMITH_VERSION_RELEASE_DATE` (default `""`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"appsmith/appsmith-editor:v1.6.20"`)
* `name` (required)
* `namespace` (required)
* `nginx_conf_template` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

