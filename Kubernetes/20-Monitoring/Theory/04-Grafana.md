# Grafana

## What is Grafana?

Grafana is an open-source visualization and observability platform used to display metrics, logs, and traces collected from different monitoring systems.

Unlike Prometheus, which stores and queries metrics, **Grafana focuses on visualizing data**.

Think of it this way:

```
Prometheus  -> Stores metrics
Grafana     -> Visualizes metrics
```

Grafana can connect to multiple data sources, including:

- Prometheus
- Loki
- Elasticsearch
- InfluxDB
- MySQL
- PostgreSQL
- CloudWatch
- Azure Monitor

In our monitoring setup, Grafana uses **Prometheus as its data source**.

---

# Why do we need Grafana?

Prometheus already provides a web UI.

So why install Grafana?

Let's compare.

## Prometheus UI

Advantages

- Query metrics
- Explore metrics
- Debug PromQL
- Verify targets

Limitations

- Very basic visualization
- Not suitable for long-term dashboards
- No customizable layouts
- Limited alert management interface

---

## Grafana

Advantages

- Beautiful dashboards
- Multiple visualization types
- Interactive graphs
- Alerting
- Dashboard sharing
- Variables
- Role-based access
- Supports multiple datasources

In production environments, engineers rarely use the Prometheus UI except for debugging.

Daily monitoring happens through Grafana dashboards.

---

# Grafana Architecture

```
                    +------------------+
                    |   Kubernetes     |
                    +------------------+
                             |
                             |
          +------------------+-------------------+
          |                                      |
          |                                      |
+----------------------+              +----------------------+
| Node Exporter        |              | kube-state-metrics   |
+----------------------+              +----------------------+
          |                                      |
          +------------------+-------------------+
                             |
                             |
                    +------------------+
                    |   Prometheus     |
                    | (Stores Metrics) |
                    +------------------+
                             |
                      PromQL Queries
                             |
                             |
                    +------------------+
                    |     Grafana      |
                    +------------------+
                             |
              Dashboards / Alerts / Panels
```

Grafana **does not collect metrics**.

Grafana **does not store metrics**.

Grafana only sends PromQL queries to Prometheus and displays the results.

---

# Installing Grafana

We installed Grafana using Helm.

```bash
helm repo add grafana https://grafana.github.io/helm-charts

helm install grafana grafana/grafana
```

After installation

```
Browser
    |
Port Forward
    |
Grafana Service
    |
Grafana Pod
```

---

# Retrieving Admin Password

Grafana stores the admin password inside a Kubernetes Secret.

```bash
kubectl get secret grafana \
-o jsonpath="{.data.admin-password}" \
| base64 -d
```

Default username

```
admin
```

---

# Port Forward

We exposed Grafana locally.

```bash
kubectl port-forward svc/grafana 3000:80
```

We also created helper scripts to automate this.

```
start-monitoring.sh

pf-loop.sh
```

These scripts saved time whenever we resumed learning.

---

# Adding Prometheus Datasource

After logging into Grafana

```
Connections
        ↓
Datasources
        ↓
Add Datasource
        ↓
Prometheus
```

Datasource URL

```
http://prometheus-server
```

This works because both Grafana and Prometheus are running inside the same Kubernetes cluster.

Notice that we used the **Kubernetes Service name**, not localhost.

---

# Explore

One of the most useful Grafana features.

```
Explore
```

Explore allows us to

- execute PromQL
- inspect metrics
- verify queries
- troubleshoot dashboards

Before creating dashboards, we spent time learning Explore.

This made dashboard creation much easier.

---

# Our Learning Journey

Initially, we thought Grafana was "just dashboards."

Later we realized the workflow is actually

```
Exporter

↓

Prometheus

↓

PromQL

↓

Grafana Explore

↓

Dashboard

↓

Alert
```

Understanding PromQL first made Grafana much easier to learn.

---

# Dashboard

A dashboard is simply a collection of panels.

Example

```
----------------------------------

CPU

Memory

Disk

Network

Filesystem

----------------------------------
```

Each panel runs its own PromQL query.

---

# Panel

Every panel consists of

```
Datasource

↓

PromQL Query

↓

Visualization

↓

Panel Options
```

Changing the visualization does not change the query.

For example

```
CPU Query

↓

Stat

or

↓

Time Series
```

Same query.

Different visualization.

---

# Visualization Types

Common visualizations

- Stat
- Time Series
- Gauge
- Table
- Bar Gauge
- Pie Chart
- Heatmap

During our labs we mainly used

- Stat
- Time Series

---

# Building Our First Dashboard

Instead of importing dashboards immediately, we created our own.

Panels

- CPU Usage
- Memory Usage
- Disk Usage

This helped us understand PromQL rather than simply importing community dashboards.

---

# Example CPU Query

```promql
100 - (
avg by(instance)(
rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
)
```

This calculates

```
CPU Usage

=

100 - Idle %
```

---

# Memory Usage Query

```promql
100 *
(
1 -
(
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
)
)
```

---

# Disk Usage Query

```promql
100 * (
1 -
(
node_filesystem_avail_bytes{
mountpoint="/",
fstype!="tmpfs"
}
/
node_filesystem_size_bytes{
mountpoint="/",
fstype!="tmpfs"
}
)
)
```

---

# Our Challenges During Learning

## 1. Dashboard Import Failed

Initially we tried importing

```
Node Exporter Full

Dashboard ID

1860
```

Grafana displayed

```
Failed to fetch
```

Reason

Corporate network blocked requests to grafana.com.

Solution

We downloaded the dashboard JSON manually and later built our own dashboard instead.

---

## 2. React Monaco Editor Failed

While exploring metrics

Grafana displayed

```
React Monaco Editor failed to load
```

This was a browser/UI issue rather than a Prometheus problem.

Prometheus itself continued working normally.

---

## 3. No Data

Initially

```
node_cpu_seconds_total
```

appeared to return no data.

We verified

- Prometheus Targets
- Node Exporter
- Datasource
- Service Discovery

Eventually we confirmed Node Exporter metrics were available and the query worked correctly.

This reinforced an important debugging lesson:

Always verify metrics directly in Prometheus before blaming Grafana.

---

# Key Learning

Grafana is **not** the monitoring system.

Prometheus is the monitoring system.

Grafana is the visualization layer built on top of Prometheus.

---

# Best Practices

- Learn PromQL before building dashboards.
- Verify queries in Explore first.
- Build your own dashboard before importing community dashboards.
- Keep dashboards simple.
- Use meaningful panel titles.
- Prefer Kubernetes Service names instead of IP addresses.
- Verify metrics in Prometheus whenever a dashboard shows "No Data."

---

# Interview Questions

### Why do we need Grafana if Prometheus already has a UI?

### Does Grafana store metrics?

### Can Grafana work without Prometheus?

### Difference between Explore and Dashboard?

### Difference between Stat and Time Series panels?

### Why is PromQL knowledge important for Grafana?

### Can Grafana connect to multiple datasources?

### What happens when Grafana executes a query?

---

# Summary

Grafana is responsible for turning Prometheus metrics into meaningful visualizations and alerts.

During this module we learned how to:

- Install Grafana
- Connect Prometheus
- Explore metrics
- Build dashboards
- Write PromQL-backed panels
- Understand visualization types
- Prepare dashboards for production monitoring
