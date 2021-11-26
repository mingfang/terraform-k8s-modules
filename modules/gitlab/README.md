
# Module `gitlab`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `null`)
* `auto_devops_domain` (required)
* `env` (default `[]`)
* `gitlab_external_url` (required)
* `gitlab_root_password` (required)
* `gitlab_runners_registration_token` (required)
* `image` (default `"gitlab/gitlab-ee:latest"`)
* `mattermost_external_url` (required)
* `name` (required)
* `namespace` (default `null`)
* `node_selector` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `registry_external_url` (required)
* `replicas` (default `1`)
* `storage` (required)
* `storage_class_name` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `gitlab_external_url`
* `gitlab_runners_registration_token`
* `name`
* `port`
* `service`
* `statefulset`

## Child Modules
* `rbac` from `git::https://github.com/mingfang/terraform-k8s-modules.git//modules/kubernetes/rbac`
* `statefulset-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service`

