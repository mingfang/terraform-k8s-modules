#!/bin/bash -x
set -e

terraform plan -out=plan
terraform show -json plan > plan.json

cat plan.json | jq -r '.resource_changes[] | select(.change.actions[0]=="create" and .provider_name=="registry.terraform.io/mingfang/k8s") | .address,  (.change.after.metadata[0].namespace + "." +  .type + "." + .change.after.metadata[0].name)' | xargs -n 2 -r bash -c 'terraform import -allow-missing-config $0 $1'
