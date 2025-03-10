#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

mkdir -p modules/istio/crd
mkdir -p modules/istio-install/install

#must extract and apply CRDs first
tfextract -dir modules/istio/crd -file modules/istio-install/istio-*/install/kubernetes/operator/charts/base/files/crd-all.gen.yaml
tfextract -dir modules/istio/crd -file modules/istio-install/istio-*/install/kubernetes/operator/charts/base/files/crd-mixer.yaml