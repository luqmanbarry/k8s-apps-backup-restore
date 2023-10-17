#!/bin/bash

set -e

project_list=$1

# $1 = "resource_kind/resource_name" e.g. ns/$NS
# $2 = namespace to forcibly remove finalizers
function remove_finalizers(){
    NAME_KIND=$1
    sleep 5
    echo "Removing resources locked by finalizers if any: $NAME_KIND"
    oc patch $NAME_KIND --type json --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]' || true
    sleep 5
    oc patch $NAME_KIND --type json --patch='[ { "op": "remove", "path": "/status/finalizers" } ]' || true
    sleep 5
    oc patch $NAME_KIND --type json --patch='[ { "op": "remove", "path": "/spec/finalizers" } ]' || true
    sleep 5
    namespaceToDelete=$2
    oc get namespace "$2" -o json \
        | jq 'del(.spec.finalizers)' \
        | oc replace --raw /api/v1/namespaces/$2/finalize -f - || true
}

if [ -z "$project_list" ];
then
    echo "Namespace list must be passed as argument."
    echo "Example: sh projectCleanup.sh /path/to/namespace_list"
    exit 1
elif [ "$project_list" = '-h' ];
then
    echo "Example: sh projectCleanup.sh /path/to/namespace_list"
    exit 0
fi

NEW_LIST="/tmp/namespaces.txt"

cp $project_list $NEW_LIST

sed -i 's/---//g' $NEW_LIST
sed -i 's/ - //g' $NEW_LIST
sed -i 's/^[\\s]*- //g' $NEW_LIST
sed -i 's/^.*://g' $NEW_LIST
sed -i 's/^#.*$//g' $NEW_LIST
sed '/^$/d' $NEW_LIST

echo
echo "========================================================="
echo "You are currently on cluster: $(oc whoami --show-server)"
read -p 'Do you want to continue? (YES/NO): ' DELETE_FLAG
echo "========================================================="
echo

if [ "$DELETE_FLAG" == "YES" ];
then
    for NS in $(cat $NEW_LIST);
    do
        oc delete ns "$NS"
        remove_finalizers "ns/$NS"
    done
else
    echo "No operation carried out. Exiting..."
    exit 0
fi


