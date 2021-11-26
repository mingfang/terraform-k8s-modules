
# Module `kubernetes/job`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `backoff_limit` (default `4`)
* `command` (required)
* `env` (default `[]`)
* `image` (required)
* `name` (required)
* `namespace` (required)
* `restart_policy` (default `"OnFailure"`)

## Managed Resources
* `k8s_batch_v1_job.this` from `k8s`

