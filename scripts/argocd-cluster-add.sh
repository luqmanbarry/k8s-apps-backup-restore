#!/bin/bash

OCP_CONTEXT=$1
ARGO_CLUSTER_NAME=$2

echo "===> BEGIN: Adding the BACKUP cluster."
if [ -z "$OCP_CONTEXT" ] || [ -z "$ARGO_CLUSTER_NAME" ];
then
  echo "Backup cluster context is empty..."
  echo "Script use format: argocd-add-clusters.sh <OCP_CONTEXT> <ARGO_CLUSTER_NAME>"
  exit 1
else
 argocd cluster add "$OCP_CONTEXT" \
  --kubeconfig $HOME/.kube/config \
  --name $ARGO_CLUSTER_NAME \
  --yes
fi
echo "===> END: Adding the backup cluster."


