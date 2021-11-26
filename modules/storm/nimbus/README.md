[View Full Size](https://raw.githubusercontent.com/mingfang/terraform-k8s-modules/master/modules/storm-nimbus/diagram.svg?sanitize=true)<img src="diagram.svg"/>
Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md

Provider Requirements:
* **k8s:** (any version)
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

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip |  |
| name |  |
| ports |  |
| statefulset\_uid |  |

