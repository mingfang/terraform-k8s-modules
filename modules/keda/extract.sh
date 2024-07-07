#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

# https://github.com/kedacore/keda/releases
tfextract -dir . -url https://github.com/kedacore/keda/releases/download/v2.14.0/keda-2.14.0-core.yaml

# fix CRD empty status
sed -i -z 's|status = {\n *}|status = { "" = "" }|' *-custom_resource_definition.tf

# namespace
sed -i 's|namespace = "keda"|namespace = var.namespace|' keda-namespace.tf
sed -i 's|namespace = "keda"|namespace = k8s_core_v1_namespace.keda.metadata.0.name|' *.tf

terraform fmt .
