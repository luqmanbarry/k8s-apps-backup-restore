#!/bin/bash

echo "Deploying: Web App1"
oc project default
oc process -f sample-apps/web-app1.yaml -o yaml | oc apply -f -
sleep 10
oc get deployment,pod,svc,route,pvc -n web-app1
echo

echo "Deploying: Web App1"
oc project default
oc process -f sample-apps/web-app2.yaml -o yaml | oc apply -f -
sleep 10
oc get deploymentconfig,pod,svc,route,pvc -n web-app2
echo

echo "Deploying: Web App1"
oc project default
oc process -f sample-apps/web-app3.yaml -o yaml | oc apply -f -
sleep 10
oc get statefulset,pod,svc,route,pvc -n web-app3
echo