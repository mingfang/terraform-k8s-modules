
# Module `kubernetes/priority-class`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `description` (default `""`)
* `global_default` (default `false`)
* `name` (required)
* `value` (required)

## Managed Resources
* `k8s_scheduling_k8s_io_v1_priority_class.priority-class` from `k8s`

