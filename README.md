## terraform-k8s-modules
Terraform Kubernetes Modules

## Requirements
- Terraform 0.12 and 0.13
- Kubernetes v1.14+ (Recommended for best CRD support)
- [terraform-provider-k8s](https://github.com/mingfang/terraform-provider-k8s)

## Upgrading to Terraform 0.13
- Terraform 0.13 can automatically install this plugin.  Make sure your Terraform configuration block has the plugin information like this.
```
terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}
``` 

- If you have existing Terraform state created before Terraform 0.13 then you may have to upgrade the state using this command.
```
terraform state replace-provider 'registry.terraform.io/-/k8s' 'mingfang/k8s'
```
