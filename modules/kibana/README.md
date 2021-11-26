
# Module `kibana`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `elasticsearch_url` (default `"http://elasticsearch:9200"`)
* `env` (default `[]`)
* `image` (default `"docker.elastic.co/kibana/kibana:6.5.1"`)
* `name` (required)
* `namespace` (default `null`)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":5601}]`)
* `replicas` (default `1`)
* `server_host` (default `"0.0.0.0"`)
* `server_name` (default `"kibana"`)
* `xpack_monitoring_ui_container_elasticsearch_enabled` (default `"true"`)

## Output Values
* `deployment`
* `name`
* `port`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

