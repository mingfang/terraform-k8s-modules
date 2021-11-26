
# Module `stackstorm`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `HUBOT_SLACK_TOKEN` (required)
* `name` (default `"stackstorm"`)
* `namespace` (default `"stackstorm-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.stackstorm-keys` from `k8s`
* `k8s_core_v1_persistent_volume_claim.stackstorm-packs` from `k8s`
* `k8s_core_v1_persistent_volume_claim.stackstorm-packs-configs` from `k8s`
* `k8s_core_v1_persistent_volume_claim.stackstorm-ssh` from `k8s`
* `k8s_core_v1_persistent_volume_claim.stackstorm-virtualenvs` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.st2web` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_role_binding.admin` from `k8s`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config-chatbot-aliases` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `config-rbac-assignments` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `init-job` from [../../modules/stackstorm/init-job](../../modules/stackstorm/init-job)
* `mongodb` from [../../modules/mongodb](../../modules/mongodb)
* `rabbitmq` from [../../modules/rabbitmq](../../modules/rabbitmq)
* `redis` from [../../modules/redis](../../modules/redis)
* `st2actionrunner` from [../../modules/stackstorm/st2actionrunner](../../modules/stackstorm/st2actionrunner)
* `st2api` from [../../modules/stackstorm/st2api](../../modules/stackstorm/st2api)
* `st2auth` from [../../modules/stackstorm/st2auth](../../modules/stackstorm/st2auth)
* `st2chatops` from [../../modules/stackstorm/st2chatops](../../modules/stackstorm/st2chatops)
* `st2garbagecollector` from [../../modules/stackstorm/st2garbagecollector](../../modules/stackstorm/st2garbagecollector)
* `st2notifier` from [../../modules/stackstorm/st2notifier](../../modules/stackstorm/st2notifier)
* `st2rulesengine` from [../../modules/stackstorm/st2rulesengine](../../modules/stackstorm/st2rulesengine)
* `st2scheduler` from [../../modules/stackstorm/st2scheduler](../../modules/stackstorm/st2scheduler)
* `st2sensorcontainer` from [../../modules/stackstorm/st2sensorcontainer](../../modules/stackstorm/st2sensorcontainer)
* `st2stream` from [../../modules/stackstorm/st2stream](../../modules/stackstorm/st2stream)
* `st2timersengine` from [../../modules/stackstorm/st2timersengine](../../modules/stackstorm/st2timersengine)
* `st2web` from [../../modules/stackstorm/st2web](../../modules/stackstorm/st2web)
* `st2workflowengine` from [../../modules/stackstorm/st2workflowengine](../../modules/stackstorm/st2workflowengine)

