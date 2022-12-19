
# Module `aws/aws-cluster-autoscaler`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CLUSTER_NAME` (required)
* `annotations` (default `{}`)
* `cordon-node-before-terminating` (default `true`)
* `env` (default `[]`)
* `ignore-daemonsets-utilization` (default `true`)
* `image` (default `"k8s.gcr.io/autoscaling/cluster-autoscaler:v1.25.0"`)
* `name` (default `"aws-cluster-autoscaler"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"cpu":"100m","memory":"600Mi"},"requests":{"cpu":"100m","memory":"600Mi"}}`)

## Output Values
* `deployment`
* `name`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

