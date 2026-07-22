# PromQL (Prometheus Query Language)

PromQL is the query language used to retrieve, filter, aggregate, and analyze metrics stored in Prometheus.

It allows you to answer questions such as:

- Is a node down?
- How much CPU is being used?
- Which Pod restarted recently?
- How much memory is available?
- Which namespace has the most Pods?

---

# Basic Metric Selection

The simplest PromQL query is the metric name itself.

Example:

```promql
up
```

Returns the latest value of every `up` time series.

Example:

```promql
node_memory_MemAvailable_bytes
```

Returns the current available memory.

---

# PromQL Data Types

PromQL works with four data types.

## Instant Vector

Returns the latest value of one or more time series.

Example:

```promql
up
```

---

## Range Vector

Returns multiple samples over a time range.

Example:

```promql
up[5m]
```

---

## Scalar

A single numeric value.

---

## String

Text value (rarely used).

---

# Label Filtering

Metrics can be filtered using labels.

Example:

```promql
up{job="prometheus"}
```

Multiple filters:

```promql
up{
job="node-exporter",
instance="worker1"
}
```

---

# Label Operators

Equal

```promql
=
```

Not Equal

```promql
!=
```

Regex Match

```promql
=~
```

Negative Regex

```promql
!~
```

Example:

```promql
up{job=~".*node.*"}
```

---

# Aggregation Functions

## Sum

```promql
sum(node_memory_MemAvailable_bytes)
```

---

## Average

```promql
avg(node_memory_MemAvailable_bytes)
```

---

## Maximum

```promql
max(node_memory_MemAvailable_bytes)
```

---

## Minimum

```promql
min(node_memory_MemAvailable_bytes)
```

---

## Count

```promql
count(up)
```

---

# Grouping

Aggregate metrics by labels.

Example:

```promql
sum by(instance)(
node_memory_MemAvailable_bytes
)
```

Count Pods per namespace:

```promql
count by(namespace)(
kube_pod_info
)
```

Count targets by job:

```promql
count by(job)(
up
)
```

---

# Counter Functions

## rate()

Calculates the average increase per second.

```promql
rate(process_cpu_seconds_total[5m])
```

---

## increase()

Calculates the total increase.

```promql
increase(http_requests_total[5m])
```

---

## irate()

Calculates the rate using only the last two samples.

Useful for highly responsive dashboards.

```promql
irate(process_cpu_seconds_total[5m])
```

---

# Histogram Function

Calculate quantiles from Histogram buckets.

```promql
histogram_quantile(
0.95,
rate(http_request_duration_seconds_bucket[5m])
)
```

Meaning:

95th percentile request latency over the last five minutes.

---

# TopK and BottomK

Top five values.

```promql
topk(
5,
node_memory_MemAvailable_bytes
)
```

Lowest five values.

```promql
bottomk(
5,
node_memory_MemAvailable_bytes
)
```

---

# Arithmetic Operators

Addition

```promql
metric1 + metric2
```

Subtraction

```promql
metric1 - metric2
```

Multiplication

```promql
metric1 * 100
```

Division

```promql
metric1 / metric2
```

---

# Common Kubernetes Queries

## Check Node Status

```promql
up
```

---

## Available Memory

```promql
node_memory_MemAvailable_bytes
```

---

## CPU Usage

```promql
rate(process_cpu_seconds_total[5m])
```

---

## Network Receive

```promql
rate(node_network_receive_bytes_total[5m])
```

---

## Disk Reads

```promql
rate(node_disk_reads_completed_total[5m])
```

---

## Pod Restarts

```promql
increase(
kube_pod_container_status_restarts_total[1h]
)
```

---

## Running Pods

```promql
kube_pod_status_phase{
phase="Running"
}
```

---

## Deployments

```promql
kube_deployment_status_replicas
```

---

## Pods per Namespace

```promql
count by(namespace)(
kube_pod_info
)
```

---

## Targets per Job

```promql
count by(job)(
up
)
```

---

# Common Alert Expressions

Node Down

```promql
up == 0
```

Low Memory

```promql
node_memory_MemAvailable_bytes < 500000000
```

Frequent Restarts

```promql
increase(
kube_pod_container_status_restarts_total[5m]
) > 5
```

---

# Most Important PromQL Functions

- rate()
- increase()
- irate()
- sum()
- avg()
- count()
- max()
- min()
- topk()
- histogram_quantile()

---

# Interview Questions

### What is PromQL?

PromQL is the query language used to retrieve and analyze metrics stored in Prometheus.

---

### Difference between Instant Vector and Range Vector?

An Instant Vector returns the latest sample of one or more time series, while a Range Vector returns all samples for one or more time series within a specified time window.

---

### Why does rate() require a Range Vector?

Because it needs multiple samples to calculate the average rate of change over time.

---

### What is histogram_quantile() used for?

It calculates latency percentiles (such as P95 or P99) from Histogram bucket metrics.

---

# Key Takeaways

- Metric names return Instant Vectors.
- `[5m]` creates a Range Vector.
- Labels filter metrics.
- Aggregation combines multiple time series.
- `rate()` is used for Counters.
- `histogram_quantile()` is used with Histograms.
- PromQL is the foundation for Grafana dashboards and Prometheus alert rules.
