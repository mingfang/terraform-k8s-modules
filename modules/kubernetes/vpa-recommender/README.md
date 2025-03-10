
# Module `kubernetes/vpa-recommender`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"k8s.gcr.io/autoscaling/vpa-recommender:0.12.0"`)
* `name` (default `"vpa-recommender"`)
* `namespace` (default `"kube-system"`)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"cpu":"200m","memory":"1000Mi"},"requests":{"cpu":"50m","memory":"500Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`

## Managed Resources
* `k8s_apiextensions_k8s_io_v1_custom_resource_definition.verticalpodautoscalercheckpoints_autoscaling_k8s_io` from `k8s`
* `k8s_apiextensions_k8s_io_v1_custom_resource_definition.verticalpodautoscalers_autoscaling_k8s_io` from `k8s`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

