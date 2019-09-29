[View Full Size](https://raw.githubusercontent.com/mingfang/terraform-provider-k8s/master/examples/gitlab/diagram.svg?sanitize=true)<img src="diagram.svg"/>
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| auto\_devops\_domain |  | string | `"1.2.3.4.nip.io"` | no |
| gitlab\_root\_password |  | string | `"changeme"` | no |
| gitlab\_runners\_registration\_token |  | string | `"wMFs1-9kpfMeKsfKsNFQ"` | no |
| ingress\_host |  | string | `"192.168.2.146"` | no |
| ingress\_node\_port\_http |  | string | `"31000"` | no |
| ingress\_node\_port\_https | not used but set to avoid conflict | string | `"31443"` | no |
| name |  | string | `"gitlab-example"` | no |

## Outputs

| Name | Description |
|------|-------------|
| urls |  |

