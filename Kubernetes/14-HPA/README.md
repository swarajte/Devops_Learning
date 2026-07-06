# 14 - Horizontal Pod Autoscaler (HPA)

## 📅 Date

06 July 2026

---

# 🎯 Goal

Learned how Kubernetes automatically scales applications by increasing or decreasing the number of Pods based on CPU utilization using the Horizontal Pod Autoscaler (HPA).

---

# 🧠 Why HPA?

Without HPA:

```
Traffic Increases
        ↓
Pods become overloaded
        ↓
Admin manually scales Deployment
```

Later when traffic decreases:

```
Extra Pods still running

↓

Resource & Cost Wastage
```

HPA solves this by automatically scaling Pods based on application load.

---

# 🧠 What is HPA?

Horizontal Pod Autoscaler (HPA) is a Kubernetes controller that automatically scales the **number of Pod replicas** based on observed metrics such as CPU or Memory utilization.

HPA **does not create Pods directly.**

```
HPA
   ↓
Deployment
   ↓
ReplicaSet
   ↓
Pods
```

---

# 🧠 Horizontal vs Vertical Scaling

### Horizontal Scaling

Increase the number of Pods.

```
1 Pod
   ↓
3 Pods
   ↓
6 Pods
```

### Vertical Scaling

Increase CPU/Memory of the existing Pod.

```
CPU = 200m

↓

CPU = 1000m
```

---

# 🧠 HPA Architecture

```
Users
   ↓
Application
   ↓
Pods
   ↓
Kubelet
   ↓
Metrics Server
   ↓
Metrics API
   ↓
HPA
   ↓
Deployment
   ↓
ReplicaSet
   ↓
More Pods
```

---

# 🧠 Metrics Server

Metrics Server collects CPU and Memory metrics from every Node's Kubelet and exposes them through the Kubernetes Metrics API.

Without Metrics Server:

```
kubectl top pods

↓

Metrics API not available
```

HPA cannot function using CPU/Memory metrics without Metrics Server.

---

# 🧠 Issue Faced

After installing Metrics Server:

```
kubectl top pods

↓

Metrics API not available
```

Reason:

Metrics Server could not communicate with the Kubelet because of TLS certificate validation failure.

Solution (Lab Environment):

Added:

```
--kubelet-insecure-tls
```

to the Metrics Server Deployment.

After rollout:

```
kubectl top nodes
kubectl top pods
```

started working successfully.

---

# 🧠 CPU Requests vs Limits

Example:

```yaml
resources:
  requests:
    cpu: 200m
  limits:
    cpu: 500m
```

### Requests

- Minimum CPU guaranteed to a Pod.
- Used by Kubernetes Scheduler.
- Used by HPA to calculate CPU utilization.

### Limits

- Maximum CPU a Pod can consume.
- If exceeded, Linux throttles the container.

---

# 🧠 How HPA Calculates CPU

Suppose:

```
CPU Request = 200m

Current CPU Usage = 100m
```

CPU Utilization:

```
100m / 200m

↓

50%
```

HPA compares this utilization against the configured target.

---

# 🧠 HPA Uses Average CPU

Suppose:

| Pod | CPU Utilization |
|------|----------------:|
| Pod1 | 40% |
| Pod2 | 45% |
| Pod3 | 35% |
| Pod4 | 42% |

Average CPU Utilization:

```
40 + 45 + 35 + 42

↓

162 / 4

↓

40.5%
```

HPA makes scaling decisions based on the **average CPU utilization** across all Pods.

---

# 🧠 Service in HPA

Created Service using:

```bash
kubectl expose deployment php-apache --port=80
```

Default Service Type:

```
ClusterIP
```

The Service only provides a stable endpoint and load-balances traffic across Pods.

It has **no role in HPA scaling decisions.**

---

# 🧠 Request Flow

```
BusyBox Pod

↓

http://php-apache

↓

CoreDNS

↓

ClusterIP Service

↓

Pod

↓

CPU Usage Increases

↓

Kubelet

↓

Metrics Server

↓

HPA

↓

Deployment

↓

ReplicaSet

↓

More Pods
```

---

# 🛠 Hands-on Performed

### ✔ Installed Metrics Server

Verified:

```
kubectl top nodes

kubectl top pods
```

---

### ✔ Fixed TLS Issue

Added:

```
--kubelet-insecure-tls
```

to Metrics Server.

---

### ✔ Created PHP Apache Deployment

Configured:

- CPU Request = 200m
- CPU Limit = 500m

---

### ✔ Created ClusterIP Service

Exposed Deployment using:

```
kubectl expose deployment php-apache --port=80
```

---

### ✔ Created HPA

Target:

- CPU = 50%
- Min Pods = 1
- Max Pods = 10

---

### ✔ Generated Continuous Load

Created BusyBox Pod and continuously executed:

```
wget http://php-apache
```

---

### ✔ Observed Auto Scaling

Initially:

```
1 Pod

CPU = 18%
```

After load:

```
CPU = 250%

↓

4 Pods

↓

5 Pods

↓

6 Pods
```

As traffic got distributed:

```
Average CPU

↓

41%
```

HPA stopped scaling.

---

# 🎯 Key Takeaways

- HPA scales the number of Pods.
- HPA never creates Pods directly.
- Metrics Server is mandatory for CPU/Memory-based HPA.
- CPU utilization is calculated using CPU Requests.
- HPA uses average CPU utilization across Pods.
- Service only forwards traffic.
- More Requests → Higher CPU → Metrics Server → HPA → Deployment → ReplicaSet → More Pods.

---

# 💡 Revision Summary

```
Users
   │
   ▼
ClusterIP Service
   │
   ▼
Pods
   │
   ▼
CPU Usage
   │
   ▼
Kubelet
   │
   ▼
Metrics Server
   │
   ▼
HPA
   │
   ▼
Deployment
   │
   ▼
ReplicaSet
   │
   ▼
More Pods
```

---

## 📌 One-Line Summary

**Horizontal Pod Autoscaler (HPA) automatically increases or decreases the number of Pod replicas by monitoring the average CPU/Memory utilization of Pods and updating the Deployment's replica count accordingly.**
