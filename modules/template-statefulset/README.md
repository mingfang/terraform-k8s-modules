
# Module `template-statefulset`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (required)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

## Problems

## Error: Invalid character

(at `template-statefulset/main.tf` line 29)

Single quotes are not valid. Use double quotes (") to enclose strings.

## Error: Missing key/value separator

(at `template-statefulset/main.tf` line 29)

Expected an equals sign ("=") to mark the beginning of the attribute value. If you intended to given an attribute name containing periods or spaces, write the name in quotes to create a string literal.

## Error: Argument or block definition required

(at `template-statefulset/variables.tf` line 3)

An argument or block definition is required here.

