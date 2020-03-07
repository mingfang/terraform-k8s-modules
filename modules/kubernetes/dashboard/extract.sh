#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

DIR=modules/kubernetes/dashboard

tfextract  -dir ${DIR} -url https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc5/aio/deploy/recommended.yaml
sed -i -e 's|namespace *= ".*"|namespace = var.namespace|g' ${DIR}/*.tf
sed -i -e 's|name *= "kubernetes-dashboard|name = "${var.name}|g' ${DIR}/*.tf
sed -i -e 's|"k8s-app" *= ".*"|"k8s-app" = var.name|g' ${DIR}/*.tf
