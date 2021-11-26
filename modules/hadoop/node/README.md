
# Module `hadoop/node`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `dns_policy` (default `""`)
* `image` (default `"registry.rebelsoft.com/hadoop:latest"`)
* `name` (default `"hadoop-node"`)
* `namenode` (required)
* `namespace` (default `""`)
* `node_selector` (default `{}`)
* `port_datanode_http` (default `50075`)
* `port_datanode_ipc` (default `50020`)
* `port_datanode_stream` (default `50010`)
* `port_resourcenode_http` (default `8042`)
* `priority_class_name` (default `""`)
* `replicas` (default `1`)
* `resourcemanager` (required)
* `restart_policy` (default `""`)
* `scheduler_name` (default `""`)
* `service_type` (default `""`)
* `session_affinity` (default `""`)
* `termination_grace_period_seconds` (default `30`)

## Output Values
* `cluster_ip`
* `deployment_uid`
* `name`
* `port`

## Managed Resources
* `k8s_apps_v1_deployment.this` from `k8s`
* `k8s_core_v1_service.this` from `k8s`

