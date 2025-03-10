
# Module `jupyter`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"jupyter"`)
* `namespace` (default `"jupyter-example"`)
* `user_pvc_name` (default `"jupyter-users"`)
* `user_storage` (default `"1Gi"`)

## Output Values
* `preload_images`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume.jupyter-users` from `k8s`
* `k8s_core_v1_persistent_volume_claim.alluxio` from `k8s`
* `k8s_core_v1_persistent_volume_claim.jupyter-users` from `k8s`
* `k8s_extensions_v1beta1_ingress.this` from `k8s`

## Child Modules
* `config` from [../../modules/jupyter/jupyterhub/config](../../modules/jupyter/jupyterhub/config)
* `enterprise-gateway` from [../../modules/jupyter/enterprise-gateway](../../modules/jupyter/enterprise-gateway)
* `hub` from [../../modules/jupyter/jupyterhub/hub](../../modules/jupyter/jupyterhub/hub)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `preloader` from [../../archetypes/daemonset](../../archetypes/daemonset)
* `proxy` from [../../modules/jupyter/jupyterhub/proxy](../../modules/jupyter/jupyterhub/proxy)

