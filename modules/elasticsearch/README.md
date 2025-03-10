
# Module `elasticsearch`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ES_JAVA_OPTS` (default `""`)
* `annotations` (default `{}`)
* `args` (default `null`)
* `command` (default `null`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"docker.elastic.co/elasticsearch/elasticsearch:7.17.0"`)
* `image_pull_secrets` (default `[]`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"elasticsearch"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9200}]`)
* `post_start_command` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"4Gi"},"requests":{"cpu":"1","memory":"3Gi"}}`)
* `secret` (default `null`): secret containing ca.crt, tls.crt, and tls.key to enable TLS
* `service_account_name` (default `null`)
* `storage` (default `null`)
* `storage_class` (default `null`)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

