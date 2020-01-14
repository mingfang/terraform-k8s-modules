#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

export DIR=modules/cert-manager
mkdir -p ${DIR}/tmp
mkdir -p ${DIR}/crd

rm ${DIR}/tmp/*
tfextract -dir ${DIR}/tmp -url https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager-no-webhook.yaml

# Must apply the CRDs first
mv ${DIR}/tmp/*-custom_resource_definition.tf ${DIR}/crd

rm ${DIR}/tmp/*namespace.tf
mv ${DIR}/tmp/* ${DIR}

sed -i -e 's|namespace *= "cert-manager"|namespace = var.namespace|g' ${DIR}/*tf

terraform fmt ${DIR}

#https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#publish-validation-schema-in-openapi-v2