#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

export DIR=.
mkdir -p ${DIR}

tfextract -dir ${DIR} -url https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.15.0/deployments/static/nvidia-device-plugin.yml

#namespace
rm ${DIR}/*namespace.tf
sed -i -e 's|namespace *= "ingress-nginx"|namespace = var.namespace|g' ${DIR}/*.tf

#fmt
terraform fmt ${DIR}
