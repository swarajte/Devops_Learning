# Common Troubleshooting

This document summarizes the common issues encountered during the Monitoring module and how they were resolved.

---

# 1. Prometheus CrashLoopBackOff

## Problem

Prometheus pods continuously restarted after installation.

## Cause

An incorrect installation/configuration caused Prometheus to fail during startup.

## Solution

- Uninstalled Prometheus.
- Removed associated PVCs.
- Performed a clean Helm installation.

---

# 2. Dashboard Import Failed

## Problem

Importing **Node Exporter Full (ID: 1860)** failed.

## Cause

Corporate network restrictions blocked requests to **grafana.com**.

## Solution

- Downloaded the dashboard JSON manually.
- Created a custom dashboard using PromQL.

---

# 3. React Monaco Editor Failed

## Problem

Grafana displayed:

```
React Monaco Editor failed to load
```

## Cause

Browser/UI issue.

## Solution

Refreshing the page or reopening Grafana resolved the issue.

---

# 4. No Data in Dashboard

## Problem

Panels displayed **No Data**.

## Checks Performed

- Verified Prometheus targets.
- Checked the Prometheus datasource.
- Executed the query in **Explore**.
- Confirmed Node Exporter metrics existed.

---

# 5. SMTP Not Configured

## Problem

Testing the Email Contact Point returned:

```
SMTP not configured
```

## Cause

Grafana had no SMTP server configured.

## Solution

Configure SMTP in `grafana.ini` or Helm values before testing email notifications.

---

# 6. Port Forward Issues

## Problem

Unable to access Grafana or Prometheus.

## Solution

Restart port forwarding.

```bash
kubectl port-forward svc/grafana 3000:80

kubectl port-forward svc/prometheus-server 9090:80
```

Our helper scripts:

- `start-monitoring.sh`
- `pf-loop.sh`

made reconnecting much easier.

---

# Lessons Learned

- Verify Prometheus before debugging Grafana.
- Test PromQL queries in **Explore** first.
- Build dashboards manually before importing community dashboards.
- Ensure SMTP is configured before testing email alerts.
- Keep helper scripts for repetitive tasks like port forwarding.

---

# Summary

Troubleshooting is an important part of monitoring. During this module, we encountered installation, dashboard, datasource, UI, and alerting issues. Resolving these problems gave us a better understanding of how Prometheus and Grafana work together in real-world Kubernetes environments.
