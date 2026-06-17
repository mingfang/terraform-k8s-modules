
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
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `gitlab` from [../../solutions/gitlab](../../solutions/gitlab)
* `ingress-controller` from [../../modules/kubernetes/ingress-nginx](../../modules/kubernetes/ingress-nginx)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

## Problems

## Error: Invalid character

(at `gitlab/ingress.tf` line 33)

This character is not used within the language.

## Error: Invalid character

(at `gitlab/ingress.tf` line 54)

This character is not used within the language.

## Error: Invalid character

(at `gitlab/ingress.tf` line 75)

This character is not used within the language.

## Error: Missing key/value separator

(at `gitlab/ingress.tf` line 32)

Expected an equals sign ("=") to mark the beginning of the attribute value.

