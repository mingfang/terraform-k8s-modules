#!/usr/bin/env bash

function tfextract() {
    go run cmd/extractor/*go $@
}

DIR=modules/kubernetes/dashboard

tfextract  -dir ${DIR} -url https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
sed -i -e 's|namespace *= ".*"|namespace = "${var.namespace}"|g' ${DIR}/*.tf
sed -i -e 's|name *= "kubernetes-dashboard|name = "${var.name}|g' ${DIR}/*.tf
sed -i -e 's|"k8s-app" *= ".*"|"k8s-app" = "${var.name}"|g' ${DIR}/*.tf
