#!/bin/bash

ARGO_PASS=$(oc get secret/openshift-gitops-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d)

ARGO_URL=$(oc get route openshift-gitops-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}')

argocd login --insecure --grpc-web $ARGO_URL  --username admin --password $ARGO_PASS
