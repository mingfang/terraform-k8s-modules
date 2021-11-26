
# Module `vault-k8s`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AGENT_INJECT_LOG_LEVEL` (default `"info"`)
* `AGENT_INJECT_VAULT_ADDR` (required)
* `AGENT_INJECT_VAULT_IMAGE` (default `"vault:1.7.0"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"hashicorp/vault-k8s:0.10.0"`)
* `image_leader_election` (default `"k8s.gcr.io/leader-elector:0.4"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"https","port":443}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Managed Resources
* `k8s_admissionregistration_k8s_io_v1_mutating_webhook_configuration.this` from `k8s`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)
* `rbac` from [../../modules/kubernetes/rbac](../../modules/kubernetes/rbac)

