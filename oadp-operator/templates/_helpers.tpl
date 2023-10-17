{{/*
Expand the name of the chart.fullname
*/}}
{{- define "oadp-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oadp-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oadp-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
GitOps Labels
*/}}
{{- define "oadp-operator.gitopsLabels" -}}
argocd.argoproj.io/managed-by: openshift-gitops
app.kubernetes.io/part-of: oadp-backup-restore
{{- end }}

{{/*
Common labels
*/}}
{{- define "oadp-operator.labels" -}}
helm.sh/chart: {{ include "oadp-operator.chart" . }}
{{ include "oadp-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "oadp-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oadp-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "oadp-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oadp-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "oadp-operator.namespace" }}
{{- .Release.Namespace | trunc 63 | trimSuffix "-" }}
{{- end }}
