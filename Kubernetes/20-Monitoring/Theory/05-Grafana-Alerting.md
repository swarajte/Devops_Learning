# Grafana Alerting

## What is Alerting?

Monitoring tells us **what is happening**.

Alerting tells us **when something requires our attention**.

Imagine a production server.

If CPU usage suddenly reaches **95%**, you don't want to keep staring at the Grafana dashboard all day.

Instead, you want Grafana to automatically notify you.

```
Metric exceeds threshold

↓

Alert Rule Evaluates

↓

Condition Becomes True

↓

Notification Sent
```

This is the purpose of alerting.

---

# Why Do We Need Alerting?

Dashboards are **passive**.

They only show information when someone opens them.

Alerting is **active**.

It continuously checks metrics and informs engineers when predefined conditions are met.

Without alerts:

```
Problem Occurs

↓

Nobody Notices

↓

Application Fails

↓

Customer Complains
```

With alerts:

```
Problem Occurs

↓

Grafana Detects It

↓

Notification Sent

↓

Engineer Responds

↓

Problem Fixed
```

---

# Alerting Workflow

The complete workflow is:

```
Application

↓

Exporter

↓

Prometheus

↓

PromQL Query

↓

Grafana Alert Rule

↓

Condition

↓

Contact Point

↓

Email / Slack / Teams / Webhook
```

Notice that **Prometheus provides the metrics**, while **Grafana evaluates alert rules** and sends notifications.

---

# Components of Grafana Alerting

Every alert consists of several components.

```
Metric

↓

Query

↓

Condition

↓

Evaluation

↓

Notification
```

Let's understand each one.

---

# Query

Every alert starts with a PromQL query.

Example:

```promql
100 - (
avg by(instance)(
rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
)
```

This query calculates CPU usage.

Grafana executes this query repeatedly.

---

# Condition

A query alone is not enough.

Grafana needs to know **when** the value should trigger an alert.

Example:

```
CPU Usage

IS ABOVE

80%
```

Only when the query returns a value greater than **80** does the alert become active.

During our lab, we intentionally used:

```
CPU > 5%
```

instead of 80%.

Why?

Because our machine was already using around **10–15% CPU**, making it easy to observe the complete alert lifecycle.

---

# Evaluation Interval

Grafana does not continuously execute queries.

Instead, it checks them at regular intervals.

Example:

```
Every 30 seconds
```

Meaning:

```
00:00

↓

00:30

↓

01:00

↓

01:30

↓

...
```

At every interval, Grafana evaluates the PromQL query.

---

# Pending Period

Imagine CPU briefly spikes for one second.

We usually don't want an alert for such temporary spikes.

Instead, we wait for the condition to remain true for some time.

Example:

```
CPU > 80%

for

2 minutes
```

Only if the CPU remains above 80% for two minutes will Grafana fire the alert.

This avoids unnecessary notifications.

---

# Alert Lifecycle

Every alert passes through several states.

```
Normal

↓

Pending

↓

Firing

↓

Recovered
```

Let's understand each one.

---

## 1. Normal

Everything is healthy.

```
CPU = 25%

Threshold = 80%
```

Nothing happens.

---

## 2. Pending

The condition becomes true.

Example:

```
CPU = 85%
```

Grafana starts waiting.

If the condition remains true during the pending period, the alert moves to the next state.

---

## 3. Firing

Pending period completed.

Condition still true.

Now Grafana sends a notification.

```
Email

Slack

Teams

Webhook
```

This is the state where engineers receive alerts.

---

## 4. Recovered

CPU returns to normal.

Example:

```
CPU = 35%
```

Grafana marks the alert as recovered.

Depending on configuration, a recovery notification may also be sent.

---

# Contact Points

A Contact Point defines **where notifications should be sent**.

Examples:

- Email
- Slack
- Microsoft Teams
- PagerDuty
- Discord
- Webhook

Think of it as the destination for alerts.

```
Alert

↓

Contact Point

↓

Notification
```

---

# Notification Policies

Notification Policies decide **which alerts go to which contact points**.

Example:

```
Production Alerts

↓

Slack

Critical Alerts

↓

PagerDuty

Development Alerts

↓

Email
```

This helps organize notifications in large environments.

---

# Our Alerting Lab

We created our first alert using CPU usage.

PromQL Query:

```promql
100 - (
avg by(instance)(
rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
)
```

Condition:

```
IS ABOVE

5
```

Evaluation Interval:

```
30 seconds
```

Pending Period:

```
1 minute
```

Since our CPU usage was already around **13%**, the alert quickly entered the Pending state and then moved to Firing.

This allowed us to observe the complete lifecycle without artificially stressing the system.

---

# Email Contact Point

We created an Email Contact Point.

After configuring it, we clicked **Test**.

Grafana returned the following error:

```
SMTP not configured,
check your grafana.ini config file's [smtp] section
```

Initially, this looked like an issue with the contact point.

However, the real problem was different.

---

# What We Learned

A Contact Point only stores the destination.

Example:

```
Send email to

user@example.com
```

But Grafana still needs an SMTP server to actually send the email.

Without SMTP:

```
Alert

↓

Contact Point

↓

❌ No Mail Server

↓

Email Cannot Be Sent
```

---

# SMTP Configuration

Grafana requires SMTP settings.

Example:

```ini
[smtp]
enabled = true
host = smtp.gmail.com:587
user = your_email@gmail.com
password = APP_PASSWORD
```

When running Grafana via Helm, these settings are typically provided in the Helm values file.

---

# Production Alert Flow

```
Exporter

↓

Prometheus

↓

PromQL

↓

Grafana Alert Rule

↓

Condition

↓

Contact Point

↓

SMTP / Slack API / Teams API

↓

Notification
```

---

# Best Practices

- Avoid very low thresholds in production.
- Always use a Pending period.
- Test alerts before deploying them.
- Group similar alerts together.
- Avoid alert fatigue.
- Keep alert names descriptive.
- Include useful descriptions in alerts.
- Verify PromQL queries before creating alerts.
- Monitor only meaningful metrics.

---

# Common Mistakes

### Creating alerts without testing the query

Always verify the PromQL query in Explore first.

---

### Very small Pending periods

This causes alerts for temporary spikes.

---

### Very low thresholds

Leads to constant notifications.

---

### Missing SMTP configuration

Contact Points alone cannot send emails.

An SMTP server (or another notification service) is required.

---

# Grafana Alerting vs Prometheus Alertmanager

Grafana Alerting

- Built into Grafana
- Easy to configure
- Excellent for dashboard-centric monitoring
- Suitable for small and medium deployments

Prometheus Alertmanager

- Separate component
- Integrates directly with Prometheus
- Supports grouping, deduplication, inhibition
- Commonly used in large production Kubernetes clusters

Both approaches are widely used in production environments.

---

# Interview Questions

### What is the purpose of alerting?

### Explain the alert lifecycle.

### What is a Contact Point?

### Why do we need a Pending period?

### Difference between Evaluation Interval and Pending Period?

### Why did our Email Contact Point fail?

### Does Grafana itself send emails?

### Difference between Grafana Alerting and Alertmanager?

### Why shouldn't thresholds be too low?

---

# Summary

In this module, we learned how Grafana continuously evaluates PromQL queries, determines whether conditions are met, and sends notifications through Contact Points.

We also gained hands-on experience by:

- Creating our first CPU usage alert
- Understanding the complete alert lifecycle
- Configuring an Email Contact Point
- Investigating the SMTP configuration error
- Learning how production monitoring systems notify engineers about infrastructure issues
