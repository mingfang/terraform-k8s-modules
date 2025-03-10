
# Module `aws/karpenter`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CLUSTER_ENDPOINT` (default `"https://kubernetes.default:443"`)
* `CLUSTER_NAME` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"public.ecr.aws/karpenter/controller:v0.5.1@sha256:f992d8ae64408a783b019cd354265995fa3dd4445f22d793b0f8d520209a3e42"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

