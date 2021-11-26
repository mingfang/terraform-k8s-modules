
# Module `hadoop/master`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `dns_policy` (default `""`)
* `image` (default `"registry.rebelsoft.com/hadoop:latest"`)
* `name` (default `"hadoop-master"`)
* `namespace` (default `""`)
* `node_selector` (default `{}`)
* `port_namenode_http` (default `50070`)
* `port_namenode_ipc` (default `9000`)
* `port_resourcemanager_http` (default `8088`)
* `port_resourcemanager_ipc_0` (default `8030`)
* `port_resourcemanager_ipc_1` (default `8031`)
* `port_resourcemanager_ipc_2` (default `8032`)
* `port_resourcemanager_ipc_3` (default `8033`)
* `priority_class_name` (default `""`)
* `replicas` (default `1`)
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

