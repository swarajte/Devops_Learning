# Building Dashboards

## Objective

In this lab, we created our own Grafana dashboard instead of importing community dashboards. This helped us understand how PromQL powers Grafana visualizations.

---

# Step 1 - Create a Dashboard

Navigate to

```
Dashboards

↓

New

↓

New Dashboard

↓

Add Visualization
```

Select the **Prometheus** datasource.

---

# Step 2 - CPU Usage Panel

Panel Type

```
Stat
```

Query

```promql
100 - (
avg by(instance)(
rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
)
```

Panel Title

```
CPU Usage
```

---

# Step 3 - Memory Usage Panel

Panel Type

```
Stat
```

Query

```promql
100 * (
1 -
(
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
)
)
```

Panel Title

```
Memory Usage
```

---

# Step 4 - Disk Usage Panel

Panel Type

```
Stat
```

Query

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

Panel Title

```
Disk Usage
```

---

# Step 5 - Save Dashboard

Click

```
Save Dashboard
```

Example Name

```
Node Monitoring Dashboard
```

---

# Dashboard Created

Our dashboard contained:

- CPU Usage
- Memory Usage
- Disk Usage

Each panel used a different PromQL query while sharing the same Prometheus datasource.

---

# Observations

- PromQL powers every Grafana panel.
- The same query can be displayed as a Stat or Time Series panel.
- Always test queries in **Explore** before adding them to dashboards.

---

# Challenges Faced

### Multiple Disk Values

Initially, the Disk Usage panel displayed multiple values.

Reason:

```
Multiple filesystems were matched.
```

Solution:

Filter the root filesystem.

```promql
mountpoint="/"
```

---

### Community Dashboard Import Failed

We attempted to import the **Node Exporter Full (ID: 1860)** dashboard.

Import failed because our corporate network blocked access to **grafana.com**.

Solution:

- Downloaded the JSON manually.
- Built our own dashboard to better understand PromQL.

---

# Summary

In this lab, we built a custom monitoring dashboard using PromQL queries for CPU, Memory, and Disk usage. Creating the dashboard manually helped us understand how Grafana panels interact with Prometheus metrics.
