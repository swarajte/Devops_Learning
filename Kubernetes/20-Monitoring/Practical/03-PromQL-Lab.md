# PromQL Lab

## Objective

Learn basic PromQL queries for monitoring Kubernetes workloads.

---

# Basic Queries

## Check Target Status

```promql
up
```

---

## Available Memory

```promql
node_memory_MemAvailable_bytes
```

---

## CPU Time

```promql
process_cpu_seconds_total
```

---

# Instant vs Range Vector

Instant Vector

```promql
up
```

Range Vector

```promql
up[5m]
```

---

# Counter Functions

Average Rate

```promql
rate(process_cpu_seconds_total[5m])
```

---

Total Increase

```promql
increase(process_cpu_seconds_total[5m])
```

---

Instant Rate

```promql
irate(process_cpu_seconds_total[5m])
```

---

# Aggregation

Total Memory

```promql
sum(node_memory_MemAvailable_bytes)
```

---

Average Memory

```promql
avg(node_memory_MemAvailable_bytes)
```

---

Maximum

```promql
max(node_memory_MemAvailable_bytes)
```

---

Minimum

```promql
min(node_memory_MemAvailable_bytes)
```

---

Count

```promql
count(up)
```

---

# Label Filtering

By Job

```promql
up{job="prometheus"}
```

---

By Instance

```promql
up{instance="localhost:9090"}
```

---

Regex

```promql
up{job=~".*node.*"}
```

---

# Grouping

Targets Per Job

```promql
count by(job)(up)
```

---

Pods Per Namespace

```promql
count by(namespace)(kube_pod_info)
```

---

Memory Per Instance

```promql
sum by(instance)(
node_memory_MemAvailable_bytes
)
```

---

# TopK

Top 5

```promql
topk(
5,
node_memory_MemAvailable_bytes
)
```

---

Bottom 5

```promql
bottomk(
5,
node_memory_MemAvailable_bytes
)
```

---

# Histogram

95th Percentile

```promql
histogram_quantile(
0.95,
rate(
prometheus_http_request_duration_seconds_bucket[5m]
)
)
```

---

# Real Kubernetes Queries

Running Pods

```promql
kube_pod_status_phase{
phase="Running"
}
```

---

Pod Restarts

```promql
increase(
kube_pod_container_status_restarts_total[1h]
)
```

---

Deployment Replicas

```promql
kube_deployment_status_replicas
```

---

Network Receive

```promql
rate(
node_network_receive_bytes_total[5m]
)
```

---

Disk Reads

```promql
rate(
node_disk_reads_completed_total[5m]
)
```

---

# Alert Queries

Node Down

```promql
up == 0
```

---

Low Memory

```promql
node_memory_MemAvailable_bytes < 500000000
```

---

Frequent Restarts

```promql
increase(
kube_pod_container_status_restarts_total[5m]
) > 5
```

---

# Lab Summary

During this lab, the following PromQL concepts were explored:

- Basic metric selection
- Instant and Range Vectors
- Label filtering
- Aggregation
- Grouping
- Counter functions
- Histogram functions
- Real Kubernetes monitoring queries
- Alert expressions

These queries form the foundation for Grafana dashboards and Prometheus alert rules.
