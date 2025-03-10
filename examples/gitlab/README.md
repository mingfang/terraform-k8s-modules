
# Module `gitlab`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `auto_devops_domain` (default `"1.2.3.4.nip.io"`)
* `gitlab_root_password` (default `"changeme"`)
* `gitlab_runners_registration_token` (default `"wMFs1-9kpfMeKsfKsNFQ"`)
* `name` (default `"gitlab"`)
* `namespace` (default `"gitlab-example"`)

## Output Values
* `urls`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.this` from `k8s`

## Child Modules
* `gitlab` from [../../solutions/gitlab](../../solutions/gitlab)
* `ingress-controller` from [../../modules/kubernetes/ingress-nginx](../../modules/kubernetes/ingress-nginx)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

