# Installing Prometheus

## Objective

Install Prometheus in a Kubernetes cluster using Helm and verify that it is successfully collecting metrics.

---

# Prerequisites

- Running Kubernetes Cluster
- kubectl configured
- Helm installed

Verify:

```bash
kubectl get nodes

helm version
```

---

# Add Prometheus Helm Repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update
```

---

# Install Prometheus

```bash
helm install prometheus prometheus-community/prometheus
```

---

# Verify Installation

Check Pods

```bash
kubectl get pods
```

Expected Components

- prometheus-server
- kube-state-metrics
- node-exporter
- pushgateway (optional)

---

Check Services

```bash
kubectl get svc
```

---

Check ConfigMaps

```bash
kubectl get configmaps
```

---

# Port Forward

```bash
kubectl port-forward svc/prometheus-server 9090:80
```

Open

```
http://localhost:9090
```

---

# Verify Prometheus

Open

Status

↓

Targets

Verify all targets are UP.

---

# Useful Commands

```bash
kubectl get all

kubectl describe pod <pod-name>

kubectl logs <pod-name>

helm list

helm uninstall prometheus
```

---

# Troubleshooting

### Pod Not Running

```bash
kubectl describe pod <pod-name>
```

---

### Check Logs

```bash
kubectl logs <pod-name>
```

---

### Helm Release

```bash
helm list
```

---

# Learning Outcome

- Installed Prometheus
- Verified components
- Accessed Prometheus UI
- Understood deployed resources
