# Exploring Prometheus

## Objective

Explore the Prometheus UI and understand the major sections used for monitoring and troubleshooting.

---

# Home Page

Prometheus Web UI

```
http://localhost:9090
```

Main Sections

- Graph
- Status
- Alerts
- Rules

---

# Expression Browser

Used to execute PromQL queries.

Examples

```promql
up
```

```promql
process_cpu_seconds_total
```

```promql
node_memory_MemAvailable_bytes
```

---

# Targets

Navigate

Status

↓

Targets

Observe

- Job
- Endpoint
- Last Scrape
- Scrape Duration
- Health

Healthy targets show

```
UP
```

---

# Service Discovery

Navigate

Status

↓

Service Discovery

Observe

- Kubernetes Labels
- Target Labels
- Discovery Metadata

Understand how Prometheus discovers Kubernetes resources.

---

# Configuration

Navigate

Status

↓

Configuration

Inspect

- scrape_configs
- scrape_interval
- evaluation_interval
- jobs

---

# Runtime Information

Navigate

Status

↓

Runtime & Build Information

Observe

- Prometheus Version
- Go Version
- Build Information

---

# Flags

Navigate

Status

↓

Command-Line Flags

Observe runtime flags used to start Prometheus.

---

# TSDB Status

Navigate

Status

↓

TSDB Status

Observe

- Number of Time Series
- Label Names
- Label Values
- Storage Information

---

# Important Metrics Explored

```promql
up
```

---

```promql
process_cpu_seconds_total
```

---

```promql
prometheus_http_requests_total
```

---

```promql
scrape_duration_seconds
```

---

```promql
node_memory_MemAvailable_bytes
```

---

# Learning Outcome

- Explored Prometheus UI
- Understood Targets
- Explored Service Discovery
- Viewed Configuration
- Executed basic PromQL queries
