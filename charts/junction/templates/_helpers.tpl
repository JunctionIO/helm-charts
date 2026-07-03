{{/*
Chart name, truncated and DNS1123-safe.
*/}}
{{- define "junction.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Fully qualified app name. Collapses to just the release name when the
release name already contains the chart name, to avoid "junction-junction".
*/}}
{{- define "junction.fullname" -}}
{{- if contains .Chart.Name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "junction.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/part-of: junction
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels for a given component name (e.g. "api", "http-destination-worker").
*/}}
{{- define "junction.selectorLabels" -}}
app.kubernetes.io/name: {{ include "junction.name" .context }}-{{ .component }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end -}}

{{/*
Postgres host: the bitnami subchart's primary Service when enabled, else the
externally-managed host from .Values.database.host.
*/}}
{{- define "junction.dbHost" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" .Release.Name -}}
{{- else -}}
{{- .Values.database.host -}}
{{- end -}}
{{- end -}}

{{/*
Postgres port.
*/}}
{{- define "junction.dbPort" -}}
{{- if .Values.postgresql.enabled -}}
5432
{{- else -}}
{{- .Values.database.port -}}
{{- end -}}
{{- end -}}

{{/*
RabbitMQ host: the bitnami subchart's Service when enabled, else the
externally-managed host from .Values.queue.host.
*/}}
{{- define "junction.queueHost" -}}
{{- if .Values.rabbitmq.enabled -}}
{{- printf "%s-rabbitmq" .Release.Name -}}
{{- else -}}
{{- .Values.queue.host -}}
{{- end -}}
{{- end -}}

{{/*
RabbitMQ port.
*/}}
{{- define "junction.queuePort" -}}
{{- if .Values.rabbitmq.enabled -}}
5672
{{- else -}}
{{- .Values.queue.port -}}
{{- end -}}
{{- end -}}

{{/*
Full amqp:// URL for the Go workers, built from the shared queue credentials.
*/}}
{{- define "junction.rabbitmqUrl" -}}
{{- printf "amqp://%s:%s@%s:%s/" .Values.secrets.app.queueUsername .Values.secrets.app.queuePassword (include "junction.queueHost" .) (include "junction.queuePort" .) -}}
{{- end -}}

{{/*
Name of the shared API/CLI secret.
*/}}
{{- define "junction.appSecretName" -}}
{{- printf "%s-app" (include "junction.fullname" .) -}}
{{- end -}}

{{/*
Name of the shared worker secret.
*/}}
{{- define "junction.workerSecretName" -}}
{{- printf "%s-worker" (include "junction.fullname" .) -}}
{{- end -}}
