
# Module `spot-ingest`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `annotations` (default `{}`)
* `dns_policy` (default `""`)
* `image` (default `"registry.rebelsoft.com/spot:latest"`)
* `kafka_port` (required)
* `kafka_server` (required)
* `name` (default `"spot-ingest"`)
* `namenode` (required)
* `namespace` (default `""`)
* `node_selector` (default `{}`)
* `ports` (default `[{"name":"http","port":8000}]`)
* `priority_class_name` (default `""`)
* `replicas` (default `1`)
* `restart_policy` (default `""`)
* `scheduler_name` (default `""`)
* `service_type` (default `""`)
* `session_affinity` (default `""`)
* `termination_grace_period_seconds` (default `30`)
* `zookeeper_port` (required)
* `zookeeper_server` (required)

## Output Values
* `cluster_ip`
* `deployment_uid`
* `name`
* `ports`

## Managed Resources
* `k8s_apps_v1_deployment.this` from `k8s`
* `k8s_core_v1_config_map.this` from `k8s`
* `k8s_core_v1_service.this` from `k8s`

## Data Resources
* `data.template_file.core_site` from `template`
* `data.template_file.ingest_conf` from `template`
* `data.template_file.spot` from `template`

