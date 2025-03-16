# Helm Charts Repository

A collection of Helm charts for Kubernetes deployments, focusing on monitoring and infrastructure tools.

## Overview

This repository contains custom Helm charts that are designed to simplify the deployment and management of various applications and services in Kubernetes clusters. Each chart follows Helm best practices and includes comprehensive documentation, configurable values, and production-ready defaults.

## Available Charts

### 📊 nvitop-exporter

**Version:** 0.1.0 | **App Version:** 1.5.1

A Helm chart for deploying [nvitop-exporter](https://github.com/XuehaiPan/nvitop), a Prometheus exporter for comprehensive NVIDIA GPU monitoring.

**Features:**
- 🖥️ Real-time GPU utilization monitoring
- 🌡️ Temperature and power consumption tracking
- 💾 GPU memory usage metrics
- 📈 Prometheus integration with ServiceMonitor support
- 🔄 DaemonSet deployment for cluster-wide GPU monitoring
- ⚙️ Configurable node selection and tolerations

**Use Cases:**
- GPU cluster monitoring
- ML/AI workload resource tracking
- GPU performance optimization
- Infrastructure cost monitoring

[📖 View Chart Documentation](./nvitop-exporter/README.md)

## Quick Start

### Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- kubectl configured to access your cluster

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd helm-charts
   ```

2. **Install a chart:**
   ```bash
   # Install nvitop-exporter with default values
   helm install nvitop-exporter https://ntheanh201.id.vn/helm-charts

   # Install with custom values
   helm install nvitop-exporter https://ntheanh201.id.vn/helm-charts -f custom-values.yaml

   # Install in a specific namespace
   helm install nvitop-exporter https://ntheanh201.id.vn/helm-charts --namespace monitoring --create-namespace
   ```

3. **Verify the installation:**
   ```bash
   helm list
   kubectl get pods -l app.kubernetes.io/name=nvitop-exporter
   ```

### Upgrading Charts

```bash
# Upgrade to a new version
helm upgrade nvitop-exporter ./nvitop-exporter

# Upgrade with new values
helm upgrade nvitop-exporter ./nvitop-exporter -f updated-values.yaml
```

### Uninstalling Charts

```bash
helm uninstall nvitop-exporter
```

## Repository Structure

```
helm-charts/
├── README.md                    # This file
└── nvitop-exporter/            # NVIDIA GPU monitoring chart
    ├── Chart.yaml              # Chart metadata
    ├── README.md               # Chart-specific documentation
    ├── values.yaml             # Default configuration values
    ├── templates/              # Kubernetes manifests templates
    └── charts/                 # Chart dependencies
```

## Development

### Adding New Charts

1. Create a new directory for your chart:
   ```bash
   mkdir my-new-chart
   cd my-new-chart
   ```

2. Initialize the chart structure:
   ```bash
   helm create my-new-chart
   ```

3. Follow the established patterns:
   - Include comprehensive README.md
   - Provide values file
   - Add proper labels and annotations
   - Include ServiceMonitor for Prometheus integration (if applicable)

### Testing Charts

```bash
# Lint the chart
helm lint ./chart-name

# Dry run installation
helm install --dry-run --debug chart-name ./chart-name

# Template rendering
helm template chart-name ./chart-name
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-chart`)
3. Make your changes
4. Test thoroughly
5. Update documentation
6. Submit a pull request

### Chart Guidelines

- Follow [Helm best practices](https://helm.sh/docs/chart_best_practices/)
- Include comprehensive documentation
- Provide production-ready default value files
- Use semantic versioning
- Include proper resource limits and requests
- Add health checks and readiness probes
- Support Prometheus monitoring when applicable

## Support

- 📖 [Helm Documentation](https://helm.sh/docs/)
- 🐛 [Report Issues](../../issues)
- 💬 [Discussions](../../discussions)

## License

This repository is licensed under the [MIT License](LICENSE).

---

**Maintained with ❤️ for the Kubernetes community**
