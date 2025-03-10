#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

export DIR=modules/goldpinger
mkdir -p ${DIR}

tfextract -dir ${DIR} -url https://raw.githubusercontent.com/bloomberg/goldpinger/master/extras/example-serviceaccounts.yml

# don't use NodePort
sed -i -e 's|type = "NodePort"||' ${DIR}/*service.tf
sed -i -e 's|node_port = 30080||' ${DIR}/*service.tf
sed -i -e 's|namespace *= ".*"|namespace = "${var.namespace}"|g' ${DIR}/*.tf
sed -i -e 's|name *= "goldpinger-clusterrole.*"|name = "${var.namespace}-${var.name}"|g' ${DIR}/*cluster_role*.tf
sed -i -e 's|name *= "goldpinger|name = "${var.name}|g' ${DIR}/*.tf
sed -i -e 's|"app" *= "goldpinger"|"app" = "${var.name}"|g' ${DIR}/*.tf
sed -i -e 's|service_account = "goldpinger-serviceaccount"|service_account = "${var.name}-serviceaccount"|g' ${DIR}/*.tf

terraform fmt ${DIR}