# nvitop-exporter Helm Chart

A Helm chart for deploying [nvitop-exporter](https://github.com/XuehaiPan/nvitop), a Prometheus exporter for NVIDIA GPU monitoring built on top of nvitop.

## Description

nvitop-exporter is a Python-based Prometheus exporter that provides comprehensive NVIDIA GPU monitoring capabilities. It exposes detailed GPU metrics including utilization, memory usage, temperature, and power consumption for Prometheus scraping.

**This chart deploys nvitop-exporter as a DaemonSet**, ensuring that GPU monitoring runs on all nodes with NVIDIA GPUs in your cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- NVIDIA GPU nodes with NVIDIA drivers installed
- NVIDIA Device Plugin for Kubernetes (recommended)
- Proper node labeling for GPU nodes

## Installation

### Add the Helm repository (if applicable)

```bash
# If this chart is published to a Helm repository
helm repo add your-repo https://your-repo-url
helm repo update
```

### Install the chart

```bash
# Install with default values
helm install nvitop-exporter ./nvitop-exporter

# Install with custom values
helm install nvitop-exporter ./nvitop-exporter -f custom-values.yaml

# Install in a specific namespace
helm install nvitop-exporter ./nvitop-exporter --namespace monitoring --create-namespace
```

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `python` |
| `image.tag` | Container image tag | `3.11-slim` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `nvitopExporter.port` | Port for the exporter | `5050` |
| `nvitopExporter.bindAddress` | Bind address | `0.0.0.0` |
| `nvitopExporter.extraArgs` | Additional command line arguments | `[]` |
| `nvitopExporter.env` | Environment variables | `[]` |
| `hostNetwork` | Use host networking | `false` |
| `hostPID` | Use host PID namespace | `false` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `5050` |
| `serviceMonitor.enabled` | Enable Prometheus ServiceMonitor | `false` |
| `serviceMonitor.interval` | Scrape interval | `30s` |
| `updateStrategy` | DaemonSet update strategy | `RollingUpdate` |
| `resources.limits.nvidia.com/gpu` | GPU resource limit | `1` |
| `nodeSelector` | Node selector for GPU nodes | `nvidia.com/gpu.present: "true"` |

### Example Custom Values

```yaml
# values-production.yaml

nvitopExporter:
  env:
    - name: NVIDIA_VISIBLE_DEVICES
      value: "all"

# DaemonSet specific settings
hostNetwork: false
hostPID: false

serviceMonitor:
  enabled: true
  interval: 15s

# Critical: Configure for your GPU nodes
nodeSelector:
  nvidia.com/gpu.present: "true"

tolerations:
  - key: nvidia.com/gpu
    operator: Exists
    effect: NoSchedule
  - key: gpu-dedicated
    operator: Equal
    value: "true"
    effect: NoSchedule

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
    nvidia.com/gpu: 1
  requests:
    cpu: 200m
    memory: 256Mi
    nvidia.com/gpu: 1

# DaemonSet update strategy
updateStrategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1
```

## GPU Node Configuration

### Critical: Node Selection

Since this chart uses a **DaemonSet**, proper node selection is crucial. The DaemonSet will only run on nodes that match the `nodeSelector`. Make sure your GPU nodes are properly labeled:

```bash
# Label your GPU nodes
kubectl label nodes <gpu-node-name> nvidia.com/gpu.present=true
```

### Node Selector Examples

Choose the appropriate selector for your environment:

```yaml
# Option 1: Using NVIDIA device plugin labels
nodeSelector:
  nvidia.com/gpu.present: "true"

# Option 2: Multiple selectors
nodeSelector:
  nvidia.com/gpu.present: "true"
  kubernetes.io/arch: amd64
```

## Prometheus Integration

### Using Prometheus Operator

Enable the ServiceMonitor:

```yaml
serviceMonitor:
  enabled: true
  namespace: monitoring  # Optional: specify namespace
  labels:
    prometheus: kube-prometheus
  interval: 30s
```

### Manual Prometheus Configuration

Add to your Prometheus configuration:

```yaml
scrape_configs:
  - job_name: 'nvitop-exporter'
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names:
            - default  # or your namespace
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_label_app_kubernetes_io_name]
        action: keep
        regex: nvitop-exporter
    metrics_path: /metrics
    scrape_interval: 30s
```

## Grafana Dashboard

Import the official nvitop Grafana dashboard:

1. Go to Grafana → Dashboards → Import
2. Enter dashboard ID: `22589`
3. Configure your Prometheus data source
4. Import the dashboard

## Metrics

The exporter provides the following key metrics:

- `nvitop_gpu_utilization_percent` - GPU utilization percentage
- `nvitop_gpu_memory_used_bytes` - GPU memory used in bytes
- `nvitop_gpu_memory_total_bytes` - Total GPU memory in bytes
- `nvitop_gpu_temperature_celsius` - GPU temperature in Celsius
- `nvitop_gpu_power_draw_watts` - GPU power consumption in watts
- `nvitop_process_*` - Per-process GPU usage metrics

## DaemonSet Behavior

### Scaling

- **Automatic scaling**: The DaemonSet automatically runs one pod per GPU node
- **No manual scaling**: Unlike Deployments, you cannot manually scale DaemonSets
- **Node-based scaling**: Adding/removing GPU nodes automatically adds/removes pods

### Updates

- **Rolling updates**: Pods are updated one node at a time
- **Controlled rollout**: Use `maxUnavailable` to control update speed
- **Node-by-node**: Each GPU node gets updated individually

## Troubleshooting

### No pods running

1. Check if GPU nodes match the nodeSelector:
   ```bash
   kubectl get nodes -l nvidia.com/gpu.present=true
   ```

2. Verify node labels:
   ```bash
   kubectl describe nodes <gpu-node-name>
   ```

3. Check DaemonSet status:
   ```bash
   kubectl get daemonset nvitop-exporter
   kubectl describe daemonset nvitop-exporter
   ```

### Pod not starting

1. Check if NVIDIA device plugin is running:
   ```bash
   kubectl get pods -n kube-system | grep nvidia
   ```

2. Check pod logs:
   ```bash
   kubectl logs -l app.kubernetes.io/name=nvitop-exporter
   ```

3. Verify GPU access:
   ```bash
   kubectl exec -it <pod-name> -- nvidia-smi
   ```

### No metrics available

1. Check if the exporter is running:
   ```bash
   kubectl port-forward <pod-name> 5050:5050
   curl http://localhost:5050/metrics
   ```

2. Verify service endpoints:
   ```bash
   kubectl get endpoints nvitop-exporter
   ```

## Upgrading

```bash
helm upgrade nvitop-exporter ./nvitop-exporter
```

## Uninstalling

```bash
helm uninstall nvitop-exporter
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the chart
5. Submit a pull request

## License

This chart is licensed under the Apache License 2.0.

## Support

For issues related to:
- The chart: Open an issue in this repository
- nvitop-exporter: Visit the [nvitop repository](https://github.com/XuehaiPan/nvitop)
