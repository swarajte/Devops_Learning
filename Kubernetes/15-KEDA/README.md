# 15 - KEDA (Kubernetes Event-Driven Autoscaling)

## 📅 Date

08 July 2026

---

# 🎯 Goal

Learned how KEDA (Kubernetes Event-Driven Autoscaling) automatically scales Kubernetes applications based on **external events** instead of traditional CPU/Memory metrics.

---

# 🧠 Why do we need KEDA?

## Problems with HPA

### 1. HPA only works with Metrics

HPA scales applications based on metrics like:

- CPU
- Memory

It cannot directly understand external events such as:

- RabbitMQ Queue Length
- Kafka Messages
- AWS SQS
- Azure Service Bus
- Redis Streams
- Cron Schedule

Example:

```
RabbitMQ Queue

↓

500 Messages Waiting

↓

CPU = 5%

↓

HPA thinks everything is fine ❌
```

---

### 2. HPA cannot Scale from Zero

Suppose:

```
No Users

↓

No Pods

↓

CPU = 0
```

HPA has no metrics to monitor.

Therefore it cannot automatically create the first Pod.

KEDA solves this by monitoring external systems directly.

---

# 🧠 What is KEDA?

KEDA (Kubernetes Event-Driven Autoscaling) is a Kubernetes component that scales applications based on **events** instead of only CPU or Memory.

Examples of supported events:

- RabbitMQ
- Kafka
- Redis
- AWS SQS
- Azure Queue
- Cron Schedule
- Prometheus
- PostgreSQL
- Many more...

---

# 🧠 KEDA Architecture

```
External Event

↓

KEDA Operator

↓

KEDA Metrics API

↓

HPA

↓

Deployment

↓

ReplicaSet

↓

Pods
```

KEDA **does not replace HPA**.

Instead, it works together with HPA by supplying external metrics.

---

# 🧠 KEDA Components

After installation, three Pods were created inside the `keda` namespace.

### keda-operator

The brain of KEDA.

Responsibilities:

- Watches ScaledObjects
- Monitors external events
- Makes scaling decisions

---

### keda-admission-webhooks

Validates KEDA resources before Kubernetes accepts them.

Example:

- Checks if ScaledObject YAML is valid.

---

### keda-operator-metrics-apiserver

Provides external metrics (RabbitMQ, Kafka, Cron etc.) to HPA.

---

# 🧠 New Resources Installed

KEDA installs new CRDs:

```
ScaledObject

ScaledJob

TriggerAuthentication
```

The most commonly used resource is:

```
ScaledObject
```

It tells KEDA:

- What to scale
- When to scale
- How much to scale

---

# Demo 1 - Cron Trigger

## Objective

Automatically run an application only during office hours.

Deployment started with:

```yaml
replicas: 0
```

Initially:

```
0 Pods
```

Created a ScaledObject:

```yaml
type: cron
```

Configured:

```yaml
start: "0 9 * * *"

end: "0 18 * * *"

desiredReplicas: "5"
```

Meaning:

```
9 AM

↓

Scale to 5 Pods

-------------------

6 PM

↓

Scale back to 0 Pods
```

### Learned

- KEDA can scale applications based on time.
- Cron Trigger is useful for office-hour applications, scheduled workloads and batch processing.
- No CPU metrics are involved.

---

# Demo 2 - RabbitMQ Trigger

## Queue Basics

A Queue is a temporary waiting area where messages stay until processed.

Example:

```
Customer

↓

Places Order

↓

RabbitMQ Queue

↓

Consumer

↓

Order Processed
```

---

## RabbitMQ

RabbitMQ acts as the Message Broker.

It stores messages inside queues.

Example:

```
Order-1

Order-2

Order-3

...

Order-50
```

---

## Components Used

### RabbitMQ

Stores incoming messages.

---

### Publisher

Publishes fake orders into RabbitMQ.

Runs once as a Kubernetes Job.

---

### Consumer

Reads messages from RabbitMQ.

Processes each order.

Acknowledges completion.

---

### KEDA

Monitors RabbitMQ Queue Length.

Creates Consumer Pods automatically when queue length increases.

---

# Authentication

RabbitMQ is password protected.

Created:

- Secret
- TriggerAuthentication

KEDA uses these credentials to connect to RabbitMQ.

---

# ScaledObject

Configured:

```yaml
type: rabbitmq
```

Meaning:

Monitor RabbitMQ.

---

```yaml
queueName: orders
```

Watch the `orders` queue.

---

```yaml
mode: QueueLength
```

Scale based on queue length.

---

```yaml
value: "5"
```

Target queue length per consumer.

---

```yaml
pollingInterval: 5
```

Check RabbitMQ every 5 seconds.

---

```yaml
cooldownPeriod: 30
```

Wait 30 seconds before scaling down after the queue becomes empty.

---

# RabbitMQ Hands-on Flow

Created:

- RabbitMQ Deployment
- RabbitMQ Service
- Consumer Deployment (0 replicas)
- Publisher Job
- Secret
- TriggerAuthentication
- ScaledObject

Built:

- order-consumer image
- order-publisher image

Loaded images into Kind cluster.

Ran Publisher Job.

Observed:

```
50 Orders Published

↓

RabbitMQ Queue

↓

KEDA detects Queue Length

↓

Consumer Pods Created

↓

Orders Processed

↓

Queue Empty

↓

30 Seconds

↓

Scale Back to 0 Pods
```

---

# Overall Scaling Flow

```
External Event

↓

Cron Trigger
OR
RabbitMQ Queue

↓

KEDA Operator

↓

KEDA Metrics API

↓

HPA

↓

Deployment

↓

ReplicaSet

↓

Pods
```

---

# HPA vs KEDA

| HPA | KEDA |
|------|------|
| CPU / Memory Based | Event Based |
| Cannot monitor RabbitMQ | Monitors RabbitMQ |
| Cannot monitor Kafka | Monitors Kafka |
| Cannot monitor Cron | Monitors Cron |
| Usually cannot scale from 0 | Can scale from 0 |
| Best for Web Apps | Best for Event-driven Apps |

---

# Key Takeaways

- KEDA enables Event-Driven Autoscaling.
- KEDA works together with HPA.
- KEDA installs new CRDs like ScaledObject.
- ScaledObject tells KEDA what resource to scale.
- KEDA supports Cron-based scaling.
- KEDA supports RabbitMQ Queue-based scaling.
- RabbitMQ follows the Producer → Queue → Consumer architecture.
- Publisher sends messages.
- Consumer processes messages.
- KEDA scales Consumers based on Queue Length.
- KEDA automatically scales applications back to zero when no events remain.

---

# Interview Questions

### What problem does KEDA solve?

Scaling applications using external events instead of only CPU/Memory metrics.

---

### Does KEDA replace HPA?

No. KEDA internally creates and manages an HPA while supplying external metrics.

---

### What is a ScaledObject?

A KEDA custom resource that defines:

- What to scale
- Which trigger to monitor
- Scaling limits

---

### Difference between Cron Trigger and RabbitMQ Trigger?

**Cron Trigger**

- Time-based scaling.

**RabbitMQ Trigger**

- Queue Length-based scaling.

---

### Why use TriggerAuthentication?

To securely provide credentials for connecting to external systems such as RabbitMQ.

---

### One-Line Summary

**KEDA extends Kubernetes autoscaling by allowing applications to scale based on external events (such as time schedules, RabbitMQ queues, Kafka topics, etc.), including scaling workloads from zero Pods when no work is pending.**
