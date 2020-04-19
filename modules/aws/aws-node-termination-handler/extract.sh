#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

export DIR=modules/aws/aws-node-termination-handler
mkdir -p ${DIR}

tfextract -dir ${DIR} -url https://github.com/aws/aws-node-termination-handler/releases/download/v1.3.1/all-resources.yaml

sed -i -e 's|.* = false||' ${DIR}/*.tf
sed -i -e 's|namespace *= ".*"|namespace = var.namespace|g' ${DIR}/*.tf

terraform fmt ${DIR}