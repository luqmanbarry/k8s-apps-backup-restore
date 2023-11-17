#!/bin/bash


OBJECT_S3_URI=""
BASE_PATH="$(pwd)/oadp"
PVB_FINAL_DIR="../restore/configs"
INPUT_ARCHIVE="$BASE_PATH/pvb-crs.json.gz"
INPUT_JSON="$BASE_PATH/pvb-input.json"
META_OUT="$BASE_PATH/pvb-meta.json"
KIND_OUT="$BASE_PATH/pvb-kind.json"
LABELS_OUT="$BASE_PATH/pvb-labels.json"
SPEC_OUT="$BASE_PATH/pvb-spec.json"
RESTORE_TEMPLATES_OUT="$PVB_FINAL_DIR/pvbs.yaml"


echo "=================================================="
echo " Extract PodVolumeBackup custom resources from S3."
echo "=================================================="

read -p 'Enter the PodVolumeBackup object S3 URI: ' OBJECT_S3_URI

if [ -z "$OBJECT_S3_URI" ];
then
  echo "Object S3 URI must be provided..."
  exit 1
fi

mkdir -p $BASE_PATH

echo "Downloading s3 object..."
aws s3 cp "$OBJECT_S3_URI" "$INPUT_ARCHIVE"

if [ "$?" != "0" ] || [ ! -f "$INPUT_ARCHIVE" ];
then
  echo ""
  echo "File download failed..."
  echo ""
  exit 1
fi

echo "Extracting json file from: $INPUT_ARCHIVE"
gunzip -c $INPUT_ARCHIVE > $INPUT_JSON


echo "Preparing extracted PodVolumeBackup CRs objects..."

jq '.[] | del(.spec.tags, .spec.node, .metadata.resourceVersion, .metadata.uid, .metadata.generation, .metadata.generateName, .metadata.ownerReferences, .metadata.managedFields)' $INPUT_JSON | jq -s '.' > $META_OUT

jq '.[] |= . + {"kind": "PodVolumeBackup", "apiVersion": "velero.io/v1"}' $META_OUT > $KIND_OUT

jq '.[].metadata.labels += {"argocd.argoproj.io/managed-by": "openshift-gitops", "app.kubernetes.io/part-of": "oadp-backup-restore"}' $KIND_OUT > $LABELS_OUT

jq '.[].spec += {"node": ""}' $LABELS_OUT > $SPEC_OUT

mkdir -p $PVB_FINAL_DIR
yq -Poy $SPEC_OUT >  $RESTORE_TEMPLATES_OUT


echo "Preparation Complete. File available at: $RESTORE_TEMPLATES_OUT"

