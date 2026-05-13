# AGENTS.md

## Critical rules — NEVER violate

### Never lose uncommitted changes

- **NEVER** run `git checkout -- <files>`, `git restore`, `git reset --hard`, or any command that overwrites working tree files.
- If you need to inspect the committed version of a file, use `git show HEAD:<path>` or `git diff` — never overwrite uncommitted work.
- If you accidentally lose uncommitted changes, immediately run `git reflog` to find the commit and `git checkout` to restore the state.

### Never run `terraform destroy`

- **NEVER** run `terraform destroy` unless explicitly instructed by the user.
- This is especially dangerous in production environments with running databases and services.

## Repo at a glance

`terraform-k8s-modules` is a **Terraform module monorepo** using the `mingfang/k8s` provider
(https://github.com/mingfang/terraform-k8s-modules). It has ~200 modules and ~230 examples.

```
modules/        ← reusable Terraform modules (apps, infra, k8s helpers)
  archetypes/   ← low-level base modules (deployment-service, statefulset-service, cronjob, daemonset, job)
  kubernetes/   ← k8s infra helpers (ingress-nginx, config-map, secret, rbac, kubeconfig, etc.)
  aws/          ← AWS-specific k8s modules (EBS CSI, Karpenter, cluster-autoscaler, etc.)
examples/       ← concrete deployments referencing modules from ../../modules/
versions.tf     ← root-level copy of `required_providers { k8s = { source = "mingfang/k8s" } }`
```

**Every module** needs a `versions.tf` at the top of its directory with the `mingfang/k8s` provider requirement.

## Architecture pattern — modules wrap archetypes

Most modules follow a two-level pattern:

1. **Archetypes** (`modules/archetypes/*`) — generic, parameterized wrappers around
   `k8s_apps_v1_deployment`, `k8s_apps_v1_stateful_set`, etc.
   They accept a flat `parameters` object and generate all the nested Kubernetes spec.
2. **Specific modules** — set defaults, handle domain logic, then delegate to an archetype.

**Key:** when creating a new application module, start from `generic-deployment-service`
or `generic-statefulset-service` (or the raw archetype), not from scratch.

```hcl
module "my-app" {
  source     = "../../modules/generic-deployment-service"
  name       = var.name
  namespace  = var.namespace
  image      = "myapp:latest"
  ports_map  = { http = 8080 }
  env_map    = { FOO = "bar" }
  overrides  = {}  # merge raw terraform on top of generated parameters
}
```

**StatefulSet** modules should use `generic-statefulset-service` (not deployment-service).
They add `pvcs`, `storage`, `storage_class`, `volume_claim_template_name` variables.

**CronJob** modules use `generic-cronjob`.

## Creating a new example

New examples are generated with **copier** (a Python Jinja2-based project scaffolding tool).

1. Template lives in `examples/template-example/`
2. `copier.yml` defines templated variables (`name`, `namespace`, `image`, `ports`, `command`, `args`)
3. `{{_copier_conf.answers_file}}` marks template placeholders
4. Run `copier run --answers-file examples/<new-name>/.copier-answers.yml` from the repo root

If copying manually, remember to update the `main.tf` source paths — examples typically
reference modules with `../../modules/<module-name>` or `../namespace`.

## File conventions

- **module directories** contain: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, optionally `README.md`, `<feature>.tf`
- **example directories** contain: `main.tf`, `variables.tf`, `versions.tf`, optionally `outputs.tf`, `README.md`
- Every `.tf` directory that references `k8s_*` resources needs a `versions.tf` with:
  ```hcl
  terraform {
    required_providers {
      k8s = { source = "mingfang/k8s" }
    }
  }
  ```
- `terraform.tfstate*` and `.terraform/` are gitignored — do NOT commit state files
- `.auto.tfvars` files are gitignored — local overrides live outside git

## Key gotchas

### Provider source

The module uses `mingfang/k8s`, **not** the official `hashicorp/kubernetes` provider.
When upgrading from Terraform < 0.13 state: `terraform state replace-provider 'registry.terraform.io/-/k8s' 'mingfang/k8s'`

### `overrides` pattern

Most modules accept an `overrides` map that merges on top of their generated parameters.
This is the primary extensibility mechanism — don't fork modules just to change a single field.

### Local-exec for CRD/operator installation

Some modules (like `cloudnative-pg`) use `null_resource` + `local-exec` to install CRDs via `kubectl apply`.
This runs during `terraform apply` and uses `when = destroy` for cleanup. Not idempotent with Terraform plan alone.

### CRD provider injection

The `mingfang/k8s` provider auto-injects defaults into CRD resources (e.g. `cloudnative-pg` `postgresql_parameters`).
Use `lifecycle { ignore_changes = [...] }` to avoid drift from provider-injected values.

### Ingress controller reference pattern

Examples use the pattern `module.<name>.name` and `module.<name>.ports_map.<port_name>` or `module.<name>.ports[0].port`
to reference service names and ports. Keep this convention consistent.

### Namespace management

The `namespace` module at `examples/namespace/` is the standard way to create namespaces.
It uses `count = var.is_create ? 1 : 0` so it can be toggled. Reference it as:
```hcl
module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}
```
