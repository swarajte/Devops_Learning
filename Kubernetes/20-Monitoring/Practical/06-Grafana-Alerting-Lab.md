# Grafana Alerting Lab

## Objective

In this lab, we created our first Grafana alert using CPU usage metrics and observed the complete alert lifecycle.

---

# Step 1 - Create an Alert Rule

Navigate to

```
Alerts & IRM

↓

Alert Rules

↓

New Alert Rule
```

---

# Step 2 - Configure the Query

Query

```promql
100 - (
avg by(instance)(
rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
)
```

---

# Step 3 - Configure the Condition

Condition

```
IS ABOVE
```

Threshold

```
5
```

We intentionally used **5%** instead of a production threshold to trigger the alert easily during the lab.

---

# Step 4 - Evaluation Settings

Evaluation Interval

```
30 seconds
```

Pending Period

```
1 minute
```

---

# Step 5 - Create a Contact Point

Navigate to

```
Alerts & IRM

↓

Contact Points

↓

Email
```

Provide the recipient email address and save the contact point.

---

# Step 6 - Test the Contact Point

While testing, Grafana returned:

```
SMTP not configured,
check your grafana.ini config file's [smtp] section
```

Reason:

The Contact Point was configured correctly, but Grafana had no SMTP server configured to send emails.

---

# Alert Lifecycle Observed

```
Normal

↓

Pending

↓

Firing

↓

Recovered
```

Since our CPU usage was already above **5%**, the alert quickly transitioned to the **Firing** state.

---

# What We Learned

- Alert Rules are based on PromQL queries.
- Contact Points define the notification destination.
- SMTP configuration is required for email notifications.
- Pending periods prevent alerts caused by temporary spikes.

---

# Summary

In this lab, we successfully created a CPU usage alert, configured a Contact Point, observed the alert lifecycle, and understood why email notifications require SMTP configuration.
