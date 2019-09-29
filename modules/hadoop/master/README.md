<img src="diagram.svg"/>To view the full size interactive diagram, append ```?sanitize=true``` to the raw URL.

Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| annotations |  | map | `{}` | no |
| dns\_policy |  | string | `""` | no |
| image |  | string | `"registry.rebelsoft.com/hadoop:latest"` | no |
| name |  | string | `"hadoop-master"` | no |
| namespace |  | string | `""` | no |
| node\_selector |  | map | `{}` | no |
| port\_namenode\_http |  | string | `"50070"` | no |
| port\_namenode\_ipc |  | string | `"9000"` | no |
| port\_resourcemanager\_http |  | string | `"8088"` | no |
| port\_resourcemanager\_ipc\_0 |  | string | `"8030"` | no |
| port\_resourcemanager\_ipc\_1 |  | string | `"8031"` | no |
| port\_resourcemanager\_ipc\_2 |  | string | `"8032"` | no |
| port\_resourcemanager\_ipc\_3 |  | string | `"8033"` | no |
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

