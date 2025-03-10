
# Module `vault-k8s`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AGENT_INJECT_LOG_LEVEL` (default `"info"`)
* `AGENT_INJECT_VAULT_ADDR` (required)
* `AGENT_INJECT_VAULT_IMAGE` (default `"hashicorp/vault:1.10.2"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"hashicorp/vault-k8s:1.1.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"https","port":8443}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Managed Resources
* `k8s_admissionregistration_k8s_io_v1_mutating_webhook_configuration.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.auth-delegator` from `k8s`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)
* `rbac` from [../../modules/kubernetes/rbac](../../modules/kubernetes/rbac)

