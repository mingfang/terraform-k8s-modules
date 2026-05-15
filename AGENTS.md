# AGENTS.md

## Critical rules — NEVER violate

### Never lose uncommitted changes

- **NEVER** run `git checkout -- <files>`, `git restore`, `git reset --hard`, or any command that overwrites working tree files — **in any repo, not just this one**.
- If you need to inspect the committed version of a file, use `git show HEAD:<path>` or `git diff` — never overwrite uncommitted work.
- Before removing any uncommitted changes, **always ask the user first**.
- If you accidentally lose uncommitted changes, immediately run `git reflog` to find the commit and `git checkout` to restore the state.

### Never delete terraform state

- **NEVER** delete `terraform.tfstate`, `terraform.tfstate.backup`, `.terraform.tfstate.lock.info`, `.terraform/`, or `.terraform.lock.hcl` — **in any repo**.
- These files contain live infrastructure state, provider lock files, and module downloads. Deleting them causes drift, lost tracking, and potential resource leaks.
- Never run `rm -rf` or `git clean -fd` on terraform directories without explicit user confirmation.
- If accidentally deleted, attempt recovery from backups or re-import resources with `terraform import`.
- **NEVER** run `terraform state rm`, `terraform state mv`, `terraform state push`, `terraform state pull`, or any other `terraform state` subcommand — **in any repo**.
  - Terraform state is immutable from the agent's perspective. If state and cluster drift, the correct approach is to either import the drifted resource (`terraform import`) or recreate it by removing it from state via a backup restore — but never modify state directly.
  - If the state becomes inconsistent (e.g., resource deleted in cluster but still in state), do NOT remove it from state. Instead, recreate the resource in the cluster or ask the user for guidance.

### Use git properly

- **Always check `git status` and `git diff`** before staging or committing anything. Know exactly what you're committing.
- **NEVER commit secret files** — `.auto.tfvars`, `.env`, credentials, passwords, API keys. Check `.gitignore` before staging.
- When adding a new directory to git, **verify it doesn't contain a nested `.git` directory** (sub-repo). Nested `.git` dirs confuse git and cause files to be tracked in the wrong repo. If found, ask the user how to handle it before removing or staging.
- **Before amending commits**, verify the current staged changes are correct. Amendments rewrite history and can lose data.
- **Never force-push** unless explicitly instructed by the user and after confirming the remote state.
- Use `git add -p` or explicitly name files when staging — never `git add .` blindly.
- When cleaning up untracked files, **list what will be removed first** and ask the user for confirmation.
- State files (`terraform.tfstate*`, `.terraform/`) and secret files (`.auto.tfvars`, `.env`) are in `.gitignore` — they should never be committed.

## Lessons learned

- `AGENTS.md` rules apply to **every repo** we work on, not just the one the file lives in. Always check for uncommitted changes in any repo before modifying anything.
- Never assume a file contains only local config — always ask before discarding uncommitted changes, even if they look trivial.
- **GPG signing is mandatory** for provider releases. Never remove or disable `signs:` in `.goreleaser.yml` without explicit user approval. If the GPG key fails, the issue is the key registration — not the signing config itself.
- When a GPG key needs to be published to the Terraform Registry, use the maintainer's existing trusted key (`43DFB6A3D9FE8D69`) if available. Do NOT generate a new random key for signing — that key will never be trusted by the registry.
- Before running `goreleaser release`, always verify that: (1) `GITHUB_TOKEN` is set, (2) `GPG_FINGERPRINT` env var matches a key that exists AND is registered with the registry, (3) the git working tree is clean, (4) the tag is pushed.

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

- **NEVER** create namespaces. Namespaces are managed externally and assumed to exist. Never run `kubectl create namespace` or any other command that creates namespaces — **in any repo**.
- The `namespace` module at `examples/namespace/` uses `count = var.is_create ? 1 : 0` so it can be toggled. Reference it as:
```hcl
module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}
```

### Never mark variables as sensitive

- Variables used in example modules that pass values through the `generic-deployment-service` / `generic-statefulset-service` / archetype chain **must NOT** be marked `sensitive = true`.
- The `mingfang/k8s` provider cannot render sensitive variables during plan, which causes zero containers to be populated in deployments/statefulsets, resulting in `Insufficient containers blocks` errors and pod startup failures.
- Sensitive values should still live in `.auto.tfvars` (gitignored) — just omit `sensitive = true` from the variable declaration.

### Never delete terraform state

- **NEVER** delete `terraform.tfstate`, `terraform.tfstate.backup`, `.terraform.tfstate.lock.info`, `.terraform/`, or `.terraform.lock.hcl` — **in any repo**.
- These files contain live infrastructure state, provider lock files, and module downloads. Deleting them causes drift, lost tracking, and potential resource leaks.
- Never run `rm -rf` or `git clean -fd` on terraform directories without explicit user confirmation.
- If accidentally deleted, attempt recovery from backups or re-import resources with `terraform import`.
- **NEVER** run `terraform state rm`, `terraform state mv`, `terraform state push`, `terraform state pull`, or any other `terraform state` subcommand — **in any repo**.
  - Terraform state is immutable from the agent's perspective. If state and cluster drift, the correct approach is to either import the drifted resource (`terraform import`) or recreate it by removing it from state via a backup restore — but never modify state directly.
  - If the state becomes inconsistent (e.g., resource deleted in cluster but still in state), do NOT remove it from state. Instead, recreate the resource in the cluster or ask the user for guidance.
