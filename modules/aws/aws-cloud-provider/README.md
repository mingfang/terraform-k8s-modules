
# Module `aws/aws-cloud-provider`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"us.gcr.io/k8s-artifacts-prod/provider-aws/cloud-controller-manager:v1.22.0-alpha.0"`)
* `name` (default `"aws-cloud-provider"`)
* `namespace` (default `"kube-system"`)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `resources` (default `{"requests":{"cpu":"200m"}}`)

## Output Values
* `daemonset`
* `name`

## Child Modules
* `daemonset` from [../../../archetypes/daemonset](../../../archetypes/daemonset)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

