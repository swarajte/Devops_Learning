# Monitoring Architecture

## Introduction

Modern applications are distributed across multiple servers, containers, and Kubernetes clusters.

Monitoring helps us answer important questions such as:

- Is the application running?
- How much CPU is being used?
- Is memory running out?
- Is disk space full?
- Are Kubernetes Pods healthy?
- How many requests are being served?
- Has anything failed?

Without monitoring, engineers would only discover problems after users report them.

A good monitoring system continuously collects metrics, stores them, visualizes them, and alerts engineers whenever something abnormal occurs.

---

# Complete Monitoring Architecture

```
                           Kubernetes Cluster
---------------------------------------------------------------------------------

                    +-----------------------------+
                    |     Applications / Pods     |
                    +-----------------------------+
                              |
                              |
            +-----------------+------------------+
            |                                    |
            |                                    |
+--------------------------+        +---------------------------+
|     Node Exporter        |        |    kube-state-metrics     |
| (Node Metrics Exporter)  |        | (Kubernetes Object State) |
+--------------------------+        +---------------------------+
            |                                    |
            +-----------------+------------------+
                              |
                    HTTP /metrics Endpoint
                              |
                              |
                      +-------------------+
                      |    Prometheus     |
                      |                   |
                      | Scrapes Metrics   |
                      | Stores Time Series|
                      +-------------------+
                              |
                         PromQL Queries
                              |
                              |
                      +-------------------+
                      |     Grafana       |
                      | Dashboards        |
                      | Explore           |
                      | Alert Rules       |
                      +-------------------+
                              |
                              |
                      Contact Points
                              |
                              |
      -----------------------------------------------------
      |             |              |            |
    Email         Slack         Teams       Webhook
```

---

# Monitoring Workflow

The monitoring process follows a simple flow.

```
Metrics Generated

↓

Metrics Exposed

↓

Metrics Collected

↓

Metrics Stored

↓

Metrics Queried

↓

Metrics Visualized

↓

Alerts Generated
```

Every component has a specific responsibility.

---

# Step 1 — Applications Generate Metrics

Every application continuously produces information.

Examples:

- CPU Usage
- Memory Usage
- HTTP Requests
- Response Time
- Errors
- Disk Usage
- Network Traffic

However, applications usually do **not** expose these metrics in a format that Prometheus understands.

This is where exporters become useful.

---

# Step 2 — Exporters Expose Metrics

An exporter converts application or system information into Prometheus metrics.

Examples:

### Node Exporter

Provides operating system metrics such as:

- CPU
- Memory
- Disk
- Filesystem
- Network

Example metrics:

```
node_cpu_seconds_total

node_memory_MemAvailable_bytes

node_filesystem_size_bytes
```

---

### kube-state-metrics

Provides Kubernetes object information.

Examples:

- Deployments
- Pods
- Nodes
- ReplicaSets
- StatefulSets
- DaemonSets

Example metrics:

```
kube_pod_status_phase

kube_deployment_status_replicas

kube_node_info
```

Unlike Node Exporter, kube-state-metrics **does not inspect the operating system**.

Instead, it reads Kubernetes objects through the Kubernetes API.

---

# Step 3 — Prometheus Scrapes Metrics

Prometheus follows a **Pull Model**.

Instead of exporters sending data,

Prometheus periodically requests metrics.

```
Prometheus

↓

GET /metrics

↓

Exporter
```

This process is called **Scraping**.

The default scrape interval is often:

```
15 seconds
```

Every scrape creates a new data point in Prometheus.

---

# Step 4 — Time Series Database (TSDB)

Prometheus stores every metric inside its Time Series Database.

Each data point contains:

```
Metric Name

+

Labels

+

Timestamp

+

Value
```

Example:

```
Metric:

node_cpu_seconds_total

Labels:

instance=node1

cpu=0

mode=idle

Timestamp:

10:35:00

Value:

85341.2
```

This allows Prometheus to display historical trends.

---

# Step 5 — Querying with PromQL

Once metrics are stored,

PromQL is used to retrieve and analyze them.

Examples:

CPU Usage

```promql
rate(node_cpu_seconds_total[5m])
```

Memory

```promql
node_memory_MemAvailable_bytes
```

Disk

```promql
node_filesystem_avail_bytes
```

PromQL enables filtering, aggregation, mathematical calculations, and time-based analysis.

---

# Step 6 — Grafana Visualization

Grafana connects to Prometheus as a datasource.

It does **not** store metrics.

Whenever a dashboard loads,

Grafana sends a PromQL query to Prometheus.

```
Dashboard

↓

PromQL

↓

Prometheus

↓

Results

↓

Visualization
```

This is why dashboards always display the latest data stored by Prometheus.

---

# Step 7 — Dashboards

Dashboards organize multiple visualizations into a single screen.

During our lab, we created a dashboard containing:

- CPU Usage
- Memory Usage
- Disk Usage

Each panel executed its own PromQL query.

---

# Step 8 — Alerting

Grafana periodically evaluates alert rules.

Example:

```
CPU Usage > 80%
```

If the condition remains true for the configured pending period,

the alert changes from:

```
Normal

↓

Pending

↓

Firing
```

Once firing,

Grafana sends notifications.

---

# Contact Points

A Contact Point defines where alerts should be delivered.

Examples:

- Email
- Slack
- Microsoft Teams
- PagerDuty
- Discord
- Webhook

During our lab,

we configured an Email Contact Point.

Testing failed because SMTP was not configured,

which taught us that Contact Points require an underlying notification service.

---

# Monitoring Components Summary

| Component | Responsibility |
|-----------|----------------|
| Node Exporter | Exposes Linux node metrics |
| kube-state-metrics | Exposes Kubernetes object metrics |
| Prometheus | Collects and stores metrics |
| PromQL | Queries stored metrics |
| Grafana | Visualizes metrics |
| Alert Rules | Detect abnormal conditions |
| Contact Points | Deliver notifications |

---

# Our Learning Journey

Our monitoring journey progressed in the following order:

```
Understanding Monitoring

↓

Prometheus Architecture

↓

Targets

↓

Metric Types

↓

PromQL

↓

Exploring Metrics

↓

Installing Grafana

↓

Connecting Datasource

↓

Building Dashboards

↓

Creating Alerts

↓

Understanding Notification Flow
```

Building the dashboard manually instead of relying on imported community dashboards helped us understand how PromQL powers Grafana visualizations.

We also encountered and resolved practical issues such as:

- Prometheus CrashLoopBackOff after an incorrect installation
- Dashboard import failure due to corporate network restrictions
- React Monaco editor loading issue
- SMTP configuration error while testing Email Contact Points

These troubleshooting experiences provided a deeper understanding of how the monitoring stack works in real-world environments.

---

# Production Monitoring Flow

```
Application

↓

Node Exporter / kube-state-metrics

↓

Prometheus

↓

Time Series Database (TSDB)

↓

PromQL

↓

Grafana

↓

Dashboards

↓

Alert Rules

↓

Contact Points

↓

Email / Slack / Teams / PagerDuty
```

This represents the complete monitoring pipeline commonly found in Kubernetes production environments.

---

# Best Practices

- Keep scrape intervals reasonable.
- Label metrics consistently.
- Build dashboards around meaningful KPIs.
- Verify PromQL queries before creating alerts.
- Monitor infrastructure and application metrics separately.
- Use Alert Rules only for actionable conditions.
- Regularly verify Prometheus targets are healthy.
- Test notification channels before relying on them in production.

---

# Interview Questions

### Explain the complete Prometheus monitoring architecture.

### What is the role of Node Exporter?

### How is kube-state-metrics different from Node Exporter?

### Why does Prometheus use the Pull model?

### What is stored inside the Prometheus TSDB?

### Does Grafana store metrics?

### Explain the monitoring workflow from application to dashboard.

### Where does PromQL fit into the monitoring architecture?

### What happens when a Grafana dashboard loads?

### How are alerts generated in Grafana?

---

# Summary

In this module, we built a complete Kubernetes monitoring stack using Prometheus and Grafana.

We learned how metrics flow from applications through exporters into Prometheus, how PromQL retrieves those metrics, how Grafana visualizes them, and how alert rules notify engineers when predefined conditions are met.

Understanding this complete architecture provides the foundation for production-grade observability in Kubernetes.
