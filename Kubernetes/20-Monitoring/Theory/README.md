# Kubernetes Monitoring - Theory

## Date
19 July 2026

---

# Why Monitoring?

Monitoring helps us answer questions like:

- Is my application healthy?
- How much CPU/Memory is being used?
- Is a Pod restarting?
- Is a Node under pressure?
- Should an alert be triggered?

Monitoring provides visibility into the Kubernetes cluster and applications running inside it.

---

# Monitoring Stack

```
Application
      │
      ▼
Exporters
      │
      ▼
Prometheus
      │
      ▼
TSDB (Time Series Database)
      │
      ▼
PromQL
      │
      ▼
Grafana
      │
      ▼
Dashboards & Visualization
```

---

# Components Learned

## Prometheus

- Open-source monitoring system
- Pull-based architecture
- Stores metrics in TSDB
- Uses PromQL for querying

---

## Grafana

- Visualization tool
- Does NOT store metrics
- Queries Prometheus
- Displays dashboards

---

## Exporters

Expose metrics through `/metrics`.

Examples:

- node-exporter
- kube-state-metrics
- Pushgateway

---

## kube-state-metrics

Provides Kubernetes object metrics.

Examples:

- Pods
- Deployments
- Nodes
- PVCs
- ReplicaSets

Metric prefix:

```
kube_
```

---

## node-exporter

Provides Linux machine metrics.

Examples:

- CPU
- Memory
- Disk
- Filesystem
- Network

Metric prefix:

```
node_
```

---

## Pushgateway

Used for short-lived jobs.

Flow:

```
CronJob

↓

Pushgateway

↓

Prometheus
```

---

# Prometheus Architecture

```
Targets

↓

Prometheus Server

↓

TSDB

↓

PromQL

↓

Grafana
```

---

# Important Concepts

## Target

Anything Prometheus scrapes metrics from.

Examples:

- node-exporter
- kube-state-metrics
- Prometheus itself

---

## Service Discovery

Prometheus automatically discovers Kubernetes targets using the Kubernetes API.

---

## PromQL

Query language for Prometheus.

Examples:

```
up

count(up)

kube_pod_info

node_memory_MemAvailable_bytes
```

---

# Metrics Structure

Every metric consists of:

```
Metric Name

+

Labels

+

Value
```

Example:

```
kube_pod_info{
 namespace="default",
 pod="prometheus-server",
 node="demo-keda2-control-plane"
} 1
```

---

# Labels

Labels identify metrics.

Examples:

- namespace
- pod
- node
- instance
- job

Labels are similar to SQL WHERE conditions.

---

# Grafana Data Source

Grafana connects to Prometheus using a Data Source.

Important:

```
Browser

↓

Grafana

↓

Prometheus
```

NOT

```
Browser

↓

Prometheus
```

Grafana queries Prometheus on behalf of the user.

---

# Key Learnings

✔ Pull-based monitoring

✔ Exporters expose `/metrics`

✔ Prometheus scrapes metrics

✔ TSDB stores metrics

✔ PromQL queries metrics

✔ Grafana visualizes metrics

✔ Labels are the heart of Prometheus
