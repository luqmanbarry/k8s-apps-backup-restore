#!/bin/bash

for it in {1..10}
do
    oc delete pod --all-namespaces  -l 'app in (web-app1, web-app2, web-app3)'
    echo "Iteraton $it -- Waitin for pods to come back up..."
    sleep 20

done