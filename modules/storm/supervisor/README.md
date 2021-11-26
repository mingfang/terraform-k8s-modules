
# Module `storm/supervisor`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `image` (default `"registry.rebelsoft.com/storm:latest"`)
* `name` (required)
* `namespace` (default `null`)
* `nimbus_seeds` (required)
* `overrides` (default `{}`)
* `port` (default `80`)
* `replicas` (default `1`)
* `storm_zookeeper_servers` (required)
* `supervisor_slots_ports` (required)

## Output Values
* `deployment`
* `name`
* `service`

## Managed Resources
* `k8s_apps_v1_deployment.this` from `k8s`
* `k8s_core_v1_config_map.this` from `k8s`
* `k8s_core_v1_service.this` from `k8s`

## Data Resources
* `data.template_file.ports` from `template`
* `data.template_file.storm` from `template`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

