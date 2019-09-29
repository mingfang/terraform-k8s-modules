<img src="diagram.svg"/>To view the full size interactive diagram, append ```?sanitize=true``` to the raw URL.

Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| namenode |  | string | n/a | yes |
| resourcemanager |  | string | n/a | yes |
| annotations |  | map | `{}` | no |
| dns\_policy |  | string | `""` | no |
| image |  | string | `"registry.rebelsoft.com/hadoop:latest"` | no |
| name |  | string | `"hadoop-node"` | no |
| namespace |  | string | `""` | no |
| node\_selector |  | map | `{}` | no |
| port\_datanode\_http |  | string | `"50075"` | no |
| port\_datanode\_ipc |  | string | `"50020"` | no |
| port\_datanode\_stream |  | string | `"50010"` | no |
| port\_resourcenode\_http |  | string | `"8042"` | no |
| priority\_class\_name |  | string | `""` | no |
| replicas |  | string | `"1"` | no |
| restart\_policy |  | string | `""` | no |
| scheduler\_name |  | string | `""` | no |
| service\_type |  | string | `""` | no |
| session\_affinity |  | string | `""` | no |
| termination\_grace\_period\_seconds |  | string | `"30"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip |  |
| deployment\_uid |  |
| name |  |
| port |  |

