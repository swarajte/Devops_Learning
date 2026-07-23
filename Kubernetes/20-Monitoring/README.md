# Kubernetes Monitoring

This module covers **Monitoring and Observability** in Kubernetes using **Prometheus** and **Grafana**. It includes monitoring architecture, PromQL, dashboard creation, alerting, troubleshooting, and hands-on labs.

---

# 📚 Topics Covered

## 📖 Theory

### Prometheus Fundamentals
- What is Monitoring?
- Monitoring vs Observability
- Why Prometheus?
- Prometheus Architecture
- Pull-based Monitoring
- Exporters
- Service Discovery
- Jobs & Targets
- Labels & Label Selectors
- Time Series Database (TSDB)
- Scrape & Evaluation Intervals

### Metric Types
- Counter
- Gauge
- Histogram
- Summary
- Real-world Examples

### PromQL
- Instant & Range Vectors
- Label Filtering
- Aggregation Functions
- rate()
- irate()
- increase()
- sum()
- avg()
- max()
- min()
- topk()
- Practical PromQL Queries

### Grafana
- Grafana Architecture
- Datasources
- Explore
- Dashboards
- Panels
- Visualization Types
- Stat Panels
- Time Series Panels
- Dashboard Import
- Custom Dashboard Creation

### Grafana Alerting
- Alert Lifecycle
- Alert Rules
- Thresholds
- Evaluation Interval
- Pending State
- Firing State
- Recovery
- Contact Points
- Notification Policies
- SMTP Overview

### Monitoring Architecture
- Node Exporter
- kube-state-metrics
- Prometheus
- Grafana
- Alert Flow

---

# 🛠 Practical

## Prometheus
- Installing Prometheus using Helm
- Exploring Targets
- Understanding `prometheus.yml`
- Prometheus UI
- Querying Metrics
- Target Health
- Service Discovery

## PromQL Lab
- CPU Usage
- Memory Usage
- Disk Usage
- Filesystem Metrics
- Network Metrics
- Node Metrics
- Kubernetes Metrics

## Grafana
- Installing Grafana using Helm
- Retrieving Admin Password
- Port Forwarding
- Adding Prometheus Datasource
- Exploring Metrics
- Building Custom Dashboards
- CPU Dashboard
- Memory Dashboard
- Disk Dashboard
- Time-Series Panels
- Dashboard Layout

## Alerting
- Creating Alert Rules
- CPU Alert Demo
- Contact Points
- Email Notification Setup
- SMTP Configuration Overview
- Alert Testing

## Troubleshooting
- Prometheus CrashLoopBackOff
- React Monaco Editor Issue
- Dashboard Import Failure
- SMTP Not Configured
- No Data in Grafana
- Port Forwarding Issues
- Prometheus Target Verification

---

# 📂 Repository Structure

```text
20-Monitoring
│
├── Theory
│   ├── Prometheus Fundamentals
│   ├── Metric Types
│   ├── PromQL
│   ├── Grafana
│   ├── Grafana Alerting
│   └── Monitoring Architecture
│
├── Practical
│   ├── Installing Prometheus
│   ├── Exploring Prometheus
│   ├── PromQL Lab
│   ├── Installing Grafana
│   ├── Building Dashboards
│   ├── Grafana Alerting Lab
│   └── Troubleshooting
│
├── prometheus-config.yaml
├── start-monitoring.sh
├── pf-loop.sh
├── SSH_in_both_prometheus_grafana.txt
└── node-exporter-1860.json
```

---

# 🎯 Learning Outcome

After completing this module, you should be able to:

- Understand Prometheus Architecture
- Configure Prometheus in Kubernetes
- Write PromQL Queries
- Explore Metrics using Prometheus UI
- Build Custom Grafana Dashboards
- Visualize CPU, Memory and Disk Metrics
- Configure Grafana Alerts
- Create Contact Points
- Troubleshoot Monitoring Issues
- Understand Production Monitoring Workflow

---

# 🧠 Key Concepts

```text
Application / Kubernetes
          │
          ▼
Exporters
(Node Exporter / kube-state-metrics)
          │
          ▼
Prometheus
(Metric Collection)
          │
          ▼
PromQL
(Query Language)
          │
          ▼
Grafana
(Dashboards)
          │
          ▼
Alert Rules
          │
          ▼
Contact Points
(Email / Slack / Teams / Webhook)
```

---

# 🚀 Next Module

**Logging & Observability**

- Fluent Bit / Fluentd
- Loki
- Promtail
- LogQL
- Centralized Logging
- Kubernetes Log Collection
- Correlating Logs with Metrics
