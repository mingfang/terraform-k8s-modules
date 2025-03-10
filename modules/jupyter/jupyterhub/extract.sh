#!/usr/bin/env bash

function tfextract() {
    go run cmd/extractor/*go $@
}

export DIR=modules/jupyter/jupyterhub

mkdir -p ${DIR}/jupyterhub/tmp
rm ${DIR}/jupyterhub/tmp/*

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

helm template jupyterhub/jupyterhub  \
  --namespace='${var.namespace}' \
  --set proxy.secretToken=`openssl rand -hex 32` \
  --set hub.cookieSecret=`openssl rand -hex 32` \
  --set hub.db.type="sqlite" \
  --set prePuller.hook.enabled="false" \
  --set prePuller.continuous.enabled="false" \
  --set scheduling.userScheduler.enabled="false" \
  --set scheduling.userPlaceholder.enabled="false" \
  --set singleuser.defaultUrl="/lab" \
  --set singleuser.image.name='${var.singleuser_image_name}' \
  --set singleuser.image.tag='${var.singleuser_image_tag}' \
  --set singleuser.profileList='${jsonencode(var.singleuser_profile_list)}' \
  --set singleuser.storage.static.pvcName='${var.singleuser_storage_static_pvcName}' \
  --set singleuser.storage.type="static" \
  > ${DIR}/jupyterhub/tmp/jupyterhub.yaml

tfextract -dir ${DIR}/jupyterhub/tmp -f ${DIR}/jupyterhub/tmp/jupyterhub.yaml
sed -i -e 's|$${|${|g' ${DIR}/jupyterhub/tmp/hub_config-config_map.tf
sed -i -e "s|extraConfig: {}|extraConfig: \${jsonencode(merge({jupyterlab=\"c.Spawner.cmd = ['jupyter-labhub']\"}, var.hub_extraConfig))}|" ${DIR}/jupyterhub/tmp/hub_config-config_map.tf
sed -i -e "s|extraEnv: {}|extraEnv: \${jsonencode(var.singleuser_extraEnv)}|" ${DIR}/jupyterhub/tmp/hub_config-config_map.tf
sed -i -e "s|extraVolumeMounts: []|extraVolumeMounts: \${jsonencode(var.singleuser_storage_extra_volume_mounts)}|" ${DIR}/jupyterhub/tmp/hub_config-config_map.tf
sed -i -e "s|extraVolumes: []|extraVolumes: \${jsonencode(var.singleuser_storage_extra_volumes)}|" ${DIR}/jupyterhub/tmp/hub_config-config_map.tf

terraform fmt -recursive ${DIR}/jupyterhub/tmp

#manually copy the data from modules/jupyter/jupyterhub/jupyterhub/tmp/hub-config-config_map.tf to modules/jupyter/jupyterhub/config/config_map.tf