#!/usr/bin/env bash

function tfextract() {
    go run cmd/extractor/*go $@
}

export DIR=modules/kubernetes/oauth2-proxy
mkdir -p ${DIR}

tfextract -dir ${DIR} -url https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/docs/examples/auth/oauth-external-auth/oauth2-proxy.yaml

#namespace
sed -i -e 's|namespace *= "kube-system"|namespace = var.namespace|g' ${DIR}/*.tf

#name
sed -i -e 's|name *= "oauth2-proxy.*"|name = var.name|g' ${DIR}/*.tf

#label
sed -i -e 's|"k8s-app" = "oauth2-proxy"|"k8s-app" = var.name|g' ${DIR}/*.tf

#client id and secret
sed -i -e 's|"<Client ID>"|var.OAUTH2_PROXY_CLIENT_ID|g' ${DIR}/*.tf
sed -i -e 's|"<Client Secret>"|var.OAUTH2_PROXY_CLIENT_SECRET|g' ${DIR}/*.tf
sed -i -e 's|"SECRET"|var.OAUTH2_PROXY_COOKIE_SECRET|g' ${DIR}/*.tf

#fmt
terraform fmt ${DIR}
