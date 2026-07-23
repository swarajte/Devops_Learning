# Installing Grafana

## Objective

In this lab, we will install Grafana in our Kubernetes cluster using Helm and connect it with Prometheus.

By the end of this lab, we will be able to:

- Install Grafana
- Access the Grafana UI
- Retrieve the admin password
- Configure Prometheus as a datasource
- Verify the datasource connection
- Explore metrics

---

# Lab Architecture

```
                    Kubernetes Cluster

         +------------------------------+
         |          Prometheus          |
         +------------------------------+
                    ▲
                    │
              PromQL Queries
                    │
         +------------------------------+
         |           Grafana            |
         +------------------------------+
                    │
              Port Forward
                    │
                Browser
```

---

# Prerequisites

Before installing Grafana, ensure:

- Kubernetes Cluster is running
- Prometheus is already installed
- Helm is installed
- kubectl is configured

Verify cluster

```bash
kubectl get nodes
```

Verify Prometheus

```bash
kubectl get pods
```

Expected output should include pods similar to

```
prometheus-server
prometheus-kube-state-metrics
prometheus-node-exporter
```

---

# Step 1 — Add Grafana Helm Repository

```bash
helm repo add grafana https://grafana.github.io/helm-charts
```

Update repositories

```bash
helm repo update
```

---

# Step 2 — Install Grafana

```bash
helm install grafana grafana/grafana
```

Expected output

```
NAME: grafana
STATUS: deployed
```

---

# Step 3 — Verify Installation

Check pods

```bash
kubectl get pods
```

Example

```
grafana-xxxxxxxxxx-xxxxx
```

Check services

```bash
kubectl get svc
```

Example

```
grafana
```

---

# Step 4 — Retrieve Admin Password

Grafana stores credentials inside a Kubernetes Secret.

Retrieve the password

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

# Step 5 — Access Grafana

Port forward

```bash
kubectl port-forward svc/grafana 3000:80
```

Open

```
http://localhost:3000
```

Login using

Username

```
admin
```

Password

```
<Retrieved Password>
```

---

# Step 6 — Add Prometheus Datasource

Navigate to

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

Click

```
Save & Test
```

Expected

```
Datasource is working
```

---

# Why Use the Service Name?

Notice that we used

```
http://prometheus-server
```

instead of

```
localhost
```

Reason

Both Grafana and Prometheus are running inside the Kubernetes cluster.

Kubernetes DNS automatically resolves

```
prometheus-server
```

to the Prometheus Service.

---

# Step 7 — Explore Metrics

Navigate to

```
Explore
```

Select

```
Prometheus
```

Try

```promql
up
```

Expected

```
1
```

for healthy targets.

Next

```promql
node_cpu_seconds_total
```

This confirms Node Exporter metrics are available.

---

# What We Learned

Initially, Grafana looked like only a dashboard tool.

However, we discovered the actual workflow:

```
Datasource

↓

PromQL

↓

Prometheus

↓

Metrics

↓

Visualization
```

Grafana never stores metrics itself.

It simply sends PromQL queries to Prometheus.

---

# Our Experience

During setup we learned several practical lessons.

- Prometheus must be installed before Grafana.
- Datasource configuration is required before dashboards can display data.
- Kubernetes Service names simplify communication between applications.
- Explore is the best place to verify PromQL queries before creating dashboards.

---

# Verification Checklist

✅ Grafana Pod Running

```bash
kubectl get pods
```

---

✅ Grafana Service Running

```bash
kubectl get svc
```

---

✅ Login Successful

```
http://localhost:3000
```

---

✅ Prometheus Datasource Added

```
Connections

↓

Datasources
```

---

✅ Query Works

```promql
up
```

---

# Common Issues

## Port Already in Use

```
address already in use
```

Solution

Use another port

```bash
kubectl port-forward svc/grafana 3001:80
```

---

## Cannot Login

Retrieve the password again

```bash
kubectl get secret grafana \
-o jsonpath="{.data.admin-password}" \
| base64 -d
```

---

## Datasource Test Failed

Verify

```bash
kubectl get svc
```

Ensure

```
prometheus-server
```

exists.

---

# Best Practices

- Use Helm for installation.
- Verify Prometheus before configuring Grafana.
- Use Kubernetes Service names instead of IP addresses.
- Always test the datasource before creating dashboards.
- Use Explore to validate PromQL queries.

---

# Summary

In this lab, we successfully installed Grafana using Helm, connected it to Prometheus, and verified the setup by querying metrics through the Explore interface. This completed the visualization layer of our Kubernetes monitoring stack and prepared us for building custom dashboards.
