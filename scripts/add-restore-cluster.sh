#!/bin/bash

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

#rm -rf $HOME/.kube/config

argocd cluster add 'default/api-osrosapoc-lmbi-p1-openshiftapps-com:6443/AF2BPZZ' \
  --kubeconfig $HOME/.kube/config \
  --name oadp-restore-cluster \
  --yes
