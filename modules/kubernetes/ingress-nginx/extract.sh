#!/usr/bin/env bash

function tfextract() {
    go run cmd/extractor/*go $@
}

export DIR=modules/kubernetes/ingress-nginx
mkdir -p ${DIR}

tfextract -dir ${DIR} -url https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
tfextract -dir ${DIR} -url https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml

#namespace
rm ${DIR}/*namespace.tf
sed -i -e 's|namespace *= "ingress-nginx"|namespace = var.namespace|g' ${DIR}/*.tf

#name
sed -i -e 's|name *= "ingress-nginx.*"|name = var.name|g' ${DIR}/*.tf
sed -i -e 's|name *= "nginx-ingress.*"|name = var.name|g' ${DIR}/*.tf
sed -i -e 's|/ingress-nginx"|/${var.name}"|g' ${DIR}/*deployment.tf

#annotations
sed -i -e 's|= "ingress-nginx"|= var.name|g' ${DIR}/*.tf

#configmaps
sed -i -e 's|name *= "nginx-configuration|name = "${var.name}-nginx-configuration|g' ${DIR}/*config_map.tf
sed -i -e 's|/nginx-configuration"|/${var.name}-nginx-configuration"|g' ${DIR}/*deployment.tf
sed -i -e 's|name *= "tcp-services|name = "${var.name}-tcp-services|g' ${DIR}/*config_map.tf
sed -i -e 's|/tcp-services"|/${var.name}-tcp-services"|g' ${DIR}/*deployment.tf
sed -i -e 's|name *= "udp-services|name = "${var.name}-udp-services|g' ${DIR}/*config_map.tf
sed -i -e 's|/udp-services"|/${var.name}-udp-services"|g' ${DIR}/*deployment.tf

#add ingress class and extra args
sed -i -e 's|"/nginx-ingress-controller",$|"/nginx-ingress-controller",\n"--election-id=${var.name}",\n"--ingress-class=${var.ingress_class}",\njoin(",", var.extra_args),|' ${DIR}/*deployment.tf

#role
sed -i -e 's|"ingress-controller-leader-nginx"|"${var.name}-${var.ingress_class}"|g' ${DIR}/*role.tf

#fmt
terraform fmt ${DIR}
