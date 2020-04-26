#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

mkdir -p modules/istio/crd
mkdir -p modules/istio-install/install

#must run extract-crd.sh and apply the CRDs before running extract.sh

#download
pushd modules/istio-install
curl -L https://istio.io/downloadIstio | sh -
popd

#extract demo
tfextract -dir modules/istio-install/install -f modules/istio-install/istio-*/install/kubernetes/istio-demo.yaml

#remove duplicate CRDs
rm modules/istio-install/install/*custom_resource_definition.tf

#namespace
rm modules/istio-install/install/istio_system-namespace.tf
sed -i -e 's|namespace = "istio-system"|namespace = var.namespace|g' modules/istio-install/install/*.tf
sed -i -e 's| istio-system| ${var.namespace}|g' modules/istio-install/install/*.tf
sed -i -e 's|=istio-system|=${var.namespace}|g' modules/istio-install/install/*.tf
sed -i -e 's|\\"istio-system\\"|\\"${var.namespace}\\"|g' modules/istio-install/install/*.tf
sed -i -e 's|istio-system\.svc|${var.namespace}.svc|g' modules/istio-install/install/*.tf
sed -i -e 's|\.istio-system|.${var.namespace}|g' modules/istio-install/install/*.tf
sed -i -e 's|namespaces/istio-system|namespaces/${var.namespace}|g' modules/istio-install/install/*.tf
sed -i -e 's|"chart" = "istio-*"|"chart" = "istio"|g' modules/istio-install/install/*.tf

#loadbalancer
sed -i -e 's|type = "LoadBalancer"|type = var.type|g' modules/istio-install/install/*.tf

#fix resources
sed -i -e 's|"2000m"|"2"|g' modules/istio-install/install/*.tf
sed -i -e 's|"1024Mi"|"1Gi"|g' modules/istio-install/install/*.tf

#move files according to their app label
grep -o -h '"chart" *= ".*"' modules/istio-install/install/*tf \
  | uniq | awk -F '"' '{printf "%s\n%s\n", $0, $4}' \
  | xargs -d '\n' -n 2 -r sh -cx \
      'mkdir -p modules/istio/$1; grep -l "$0" modules/istio-install/install/*tf | xargs -r -I{} mv {} modules/istio/$1'
ls -d modules/istio/* | grep -v crd | xargs -I {} cp modules/istio-install/variables.tf {}

#istio
mv modules/istio-install/install/istio-reader-cluster_role.tf modules/istio/istio
mv modules/istio-install/install/istio-multi-*.tf modules/istio/istio