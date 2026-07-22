# Metric Types

Prometheus stores all collected data as **time series**, but not every metric behaves the same way.

Some metrics only increase, some increase and decrease, while others represent distributions such as request latency.

To handle these different behaviors, Prometheus defines **four metric types**:

- Counter
- Gauge
- Histogram
- Summary

---

# 1. Counter

## Definition

A **Counter** is a metric that only increases over time.

It can:

- Increase
- Stay the same
- Reset to 0 when the application restarts

It can **never decrease** during normal operation.

---

## Analogy

Think of a car's odometer.

```text
100 km
↓

150 km
↓

220 km
↓

300 km
```

The reading only increases.

---

## Common Counter Metrics

```text
http_requests_total

process_cpu_seconds_total

node_network_receive_bytes_total

kube_pod_container_status_restarts_total
```

---

## When to Use

Counters are ideal for measuring totals such as:

- HTTP Requests
- CPU Time
- Network Bytes
- Container Restarts
- Errors
- Logins

---

## Why We Use rate()

A Counter represents the total since the application started.

Example:

```text
10

↓

20

↓

35

↓

60
```

Usually we are interested in **how fast** it is increasing.

Example:

```promql
rate(process_cpu_seconds_total[5m])
```

Meaning:

> Average increase per second over the last 5 minutes.

---

# 2. Gauge

## Definition

A **Gauge** represents the current value of something.

It can:

- Increase
- Decrease
- Stay the same

---

## Analogy

Battery Percentage

```text
80%

↓

65%

↓

72%

↓

40%
```

---

## Common Gauge Metrics

```text
up

node_memory_MemAvailable_bytes

node_filesystem_avail_bytes

node_load1
```

---

## When to Use

Gauges are used for current state values such as:

- Memory Usage
- CPU Temperature
- Disk Space
- Number of Active Connections

---

## Why We Usually Don't Use rate()

Example:

```promql
node_memory_MemAvailable_bytes
```

returns the current available memory.

Using

```promql
rate(node_memory_MemAvailable_bytes[5m])
```

calculates how quickly memory changes, which is rarely useful.

---

# 3. Histogram

## Definition

A **Histogram** measures the distribution of observations by grouping values into predefined buckets.

Histograms are most commonly used for measuring:

- Request Latency
- Response Time
- Processing Time

---

## Why Histograms?

Suppose request durations are:

```text
80 ms

120 ms

150 ms

180 ms

250 ms

320 ms

450 ms

600 ms

900 ms
```

Instead of storing every value individually, Prometheus groups them into buckets.

Example:

```text
<=100 ms

<=200 ms

<=500 ms

<=1000 ms

+Inf
```

---

## Histogram Metrics

A Histogram exposes three metric families.

### _bucket

Stores cumulative bucket counts.

Example:

```text
http_request_duration_seconds_bucket
```

---

### _sum

Stores the sum of all observed values.

Example:

```text
http_request_duration_seconds_sum
```

---

### _count

Stores the total number of observations.

Example:

```text
http_request_duration_seconds_count
```

---

## Important Note

Histogram buckets are **Counters**.

Therefore functions like

```promql
rate(http_request_duration_seconds_bucket[5m])
```

work correctly.

---

## Common Histogram Metrics

```text
http_request_duration_seconds

prometheus_http_request_duration_seconds

apiserver_request_duration_seconds

scheduler_e2e_scheduling_duration_seconds
```

---

# 4. Summary

## Definition

A **Summary** also measures the distribution of observations.

Unlike Histograms, it calculates **quantiles inside the application**.

---

## Quantiles

Example:

```text
P50

P90

P95

P99
```

Example:

```text
P95 = 250 ms
```

Meaning:

95% of requests completed within 250 ms.

---

## Summary Metrics

```text
http_request_duration_seconds{
quantile="0.5"
}

http_request_duration_seconds{
quantile="0.9"
}

http_request_duration_seconds_sum

http_request_duration_seconds_count
```

Notice there is **no _bucket metric**.

---

# Histogram vs Summary

| Histogram | Summary |
|------------|----------|
| Stores Buckets | Stores Quantiles |
| Prometheus calculates percentiles | Application calculates percentiles |
| Aggregatable across multiple Pods | Not aggregatable |
| Preferred in Kubernetes | Less commonly used |

---

# Counter vs Gauge

| Counter | Gauge |
|-----------|--------|
| Only increases | Can increase and decrease |
| Used for totals | Used for current values |
| Usually queried with rate() | Usually queried directly |

---

# Metric Type Summary

| Metric Type | Can Decrease | Common Use |
|--------------|--------------|------------|
| Counter | ❌ | Requests, CPU Time, Bytes |
| Gauge | ✅ | Memory, Disk, Connections |
| Histogram | ❌ (Buckets) | Latency Distribution |
| Summary | ❌ | Latency with Quantiles |

---

# Interview Questions

### Why do we use rate() with Counters?

Because Counters continuously increase. `rate()` calculates the average increase per second over a time window.

---

### Why don't we usually use rate() on Gauges?

Because Gauges already represent the current value.

---

### Why are Histograms preferred over Summaries?

Histograms expose bucket counts that Prometheus can aggregate across multiple instances before calculating percentiles. Summary metrics calculate quantiles inside each application instance, and those quantiles cannot be accurately combined across multiple Pods or services.

---

# Key Takeaways

- Counter → Totals
- Gauge → Current State
- Histogram → Bucket-based Distribution
- Summary → Quantile-based Distribution

Understanding the behavior of each metric type helps you choose the correct PromQL functions and interpret monitoring data accurately.
