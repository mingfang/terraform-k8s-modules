
# Module `template-deployment`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (required)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

## Problems

## Error: Invalid character

(at `template-deployment/main.tf` line 27)

Single quotes are not valid. Use double quotes (") to enclose strings.

## Error: Missing key/value separator

(at `template-deployment/main.tf` line 27)

Expected an equals sign ("=") to mark the beginning of the attribute value. If you intended to given an attribute name containing periods or spaces, write the name in quotes to create a string literal.

## Error: Argument or block definition required

(at `template-deployment/variables.tf` line 3)

An argument or block definition is required here.

