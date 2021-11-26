
# Module `storm/nimbus`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `annotations` (default `{}`)
* `dns_policy` (default `""`)
* `image` (default `"registry.rebelsoft.com/storm:latest"`)
* `name` (default `"storm-nimbus"`)
* `namespace` (default `""`)
* `node_selector` (default `{}`)
* `ports` (default `[{"name":"tcp-thrift","port":6627}]`)
* `priority_class_name` (default `""`)
* `replicas` (default `1`)
* `restart_policy` (default `""`)
* `scheduler_name` (default `""`)
* `service_type` (default `""`)
* `session_affinity` (default `""`)
* `storm_zookeeper_servers` (required)
* `termination_grace_period_seconds` (default `30`)

## Output Values
* `cluster_ip`
* `name`
* `ports`
* `statefulset_uid`

## Managed Resources
* `k8s_apps_v1_stateful_set.this` from `k8s`
* `k8s_core_v1_config_map.this` from `k8s`
* `k8s_core_v1_service.this` from `k8s`
* `k8s_policy_v1beta1_pod_disruption_budget.this` from `k8s`

## Data Resources
* `data.template_file.storm` from `template`

