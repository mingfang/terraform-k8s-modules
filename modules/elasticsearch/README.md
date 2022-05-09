
# Module `elasticsearch`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ES_JAVA_OPTS` (default `""`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"docker.elastic.co/elasticsearch/elasticsearch:7.17.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9200}]`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"4Gi"},"requests":{"cpu":"250m","memory":"3Gi"}}`)
* `secret` (default `null`): secret containing ca.crt, tls.crt, and tls.key to enable TLS
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

