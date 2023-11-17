#!/bin/bash

echo "Deleting: Web App1"
oc project default
oc process -f sample-apps/web-app1.yaml -o yaml | oc delete -f -
echo

echo "Deleting: Web App2"
oc project default
oc process -f sample-apps/web-app2.yaml -o yaml | oc delete -f -
echo

echo "Deleting: Web App3"
oc project default
oc process -f sample-apps/web-app3.yaml -o yaml | oc delete -f -
echo
