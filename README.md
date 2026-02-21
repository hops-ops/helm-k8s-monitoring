# helm-k8s-monitoring

Installs the [Grafana k8s-monitoring](https://grafana.com/docs/grafana-cloud/monitor-infrastructure/kubernetes-monitoring/) Helm chart using Crossplane and the Helm provider.

## Usage

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: K8sMonitoring
metadata:
  name: k8s-monitoring
  namespace: my-namespace
spec:
  clusterName: my-cluster
```

## Configuration

| Field | Description | Default |
|-------|-------------|---------|
| `spec.clusterName` | Name of the target cluster | Required |
| `spec.namespace` | Namespace for the Helm release | `monitoring` |
| `spec.name` | Helm release name | XR metadata.name |
| `spec.labels` | Custom labels merged with defaults | `{}` |
| `spec.values` | Helm values rendered after inline defaults | `{}` |
| `spec.overrideAllValues` | Helm values replacing all defaults | `{}` |
| `spec.providerConfigRef.name` | ProviderConfig name | `clusterName` |
| `spec.providerConfigRef.kind` | ProviderConfig kind | `ProviderConfig` |

## Defaults

The chart is configured with a useful multi-signal baseline by default:

| Default | Description |
|---------|-------------|
| `cluster.name` | Set from `spec.clusterName` (required by chart validation) |
| `destinations` | Prometheus, Loki, and Tempo destinations (`prometheus/loki/tempo.<namespace>`) |
| `clusterMetrics`, `alloy-metrics` | Enables cluster metrics collection |
| `clusterEvents`, `nodeLogs`, `podLogs` | Enables logs/events collection |
| `applicationObservability` | Enables OTLP receiver on ports `4317` and `4318` |
| `prometheusOperatorObjects` | Enables Prometheus Operator object collection |
| `alloy-logs`, `alloy-singleton`, `alloy-receiver` | Enables collectors required for logs and OTLP ingest |
| `nodeExporter.enabled` | Set to `false` (prom-stack usually owns node exporter) |

Use `spec.overrideAllValues` to replace all defaults entirely.

## Examples

See the `examples/` directory:

- `minimal.yaml` - Basic installation with baseline defaults
- `standard.yaml` - Installation with custom destinations and additional features
