#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

export DIR=modules/aws/aws-ebs-csi
mkdir -p ${DIR}

kubectl kustomize https://github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master > /tmp/aws-ebs-csi.yaml
tfextract -dir ${DIR} -file /tmp/aws-ebs-csi.yaml

sed -i -e 's|namespace *= ".*"|namespace = var.namespace|g' ${DIR}/*.tf

terraform fmt ${DIR}