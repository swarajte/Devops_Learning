# Kubernetes Scheduling

## 📖 Introduction

By default, Kubernetes schedules Pods automatically on the most suitable node based on available resources and scheduling policies.

However, in real-world production environments, we often need more control over where Pods should run.

Examples:

- Database Pods should run only on dedicated database nodes.
- GPU workloads should run only on GPU-enabled nodes.
- Monitoring Pods should avoid application nodes.
- Critical workloads should be isolated from regular applications.

Kubernetes provides multiple scheduling mechanisms to achieve this.

In this section, we learned:

- Node Selector
- Node Affinity
- Taints & Tolerations

---

# Kubernetes Scheduler Flow

```
                 Pod Created
                      │
                      ▼
              Kubernetes Scheduler
                      │
        ┌─────────────┴─────────────┐
        │                           │
        ▼                           ▼
 Check Scheduling Rules       Check Available Nodes
        │                           │
        └─────────────┬─────────────┘
                      ▼
              Select Best Node
                      ▼
                 Pod Scheduled
```

---

# 1. Node Selector

## What is Node Selector?

Node Selector is the simplest scheduling mechanism in Kubernetes.

It allows a Pod to run only on nodes having a specific label.

Think of it as an **exact match filter**.

```
Pod
 │
 ▼
"I want a node where

workload = frontend"
```

Only nodes having:

```
workload=frontend
```

can run the Pod.

---

## How it works

### Step 1

Label a node.

```bash
kubectl label node multinode-worker workload=frontend
```

Verify:

```bash
kubectl get nodes --show-labels
```

---

### Step 2

Use Node Selector.

```yaml
spec:
  nodeSelector:
    workload: frontend
```

Scheduler checks every node.

```
Worker-1

workload=frontend
✅ Match

Worker-2

workload=backend
❌ Reject
```

---

## Important

If no node matches,

Pods remain:

```
Pending
```

Describe the Pod:

```bash
kubectl describe pod <pod-name>
```

Events usually show:

```
0/X nodes are available

didn't match Pod's node selector
```

---

## Pros

- Simple
- Easy to configure
- Fast scheduling

---

## Limitations

Only supports:

```
Exact Match
```

Cannot express:

- OR conditions
- NOT conditions
- Preferences
- Greater/Less than comparisons

---

# 2. Node Affinity

Node Affinity is an advanced version of Node Selector.

Instead of exact matching only, it supports:

- Required rules
- Preferred rules
- Multiple operators

---

## Required Node Affinity

```
requiredDuringSchedulingIgnoredDuringExecution
```

Meaning:

```
Pod MUST satisfy this rule.

Otherwise

↓

Pending
```

Example:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: workload
          operator: In
          values:
          - frontend
```

---

### Understanding each field

```
affinity
```

Scheduling preferences.

↓

```
nodeAffinity
```

Node-based scheduling.

↓

```
requiredDuringSchedulingIgnoredDuringExecution
```

Required while scheduling.

Ignored after Pod starts.

↓

```
matchExpressions
```

Conditions to satisfy.

---

### DuringSchedulingIgnoredDuringExecution

One of the most common interview questions.

Meaning:

```
Checked only while scheduling.
```

Example:

Node

```
workload=frontend
```

↓

Pod scheduled.

Later someone removes the label.

```
workload removed
```

Pod keeps running.

Kubernetes **does not evict** it.

---

## Preferred Node Affinity

```
preferredDuringSchedulingIgnoredDuringExecution
```

Means:

```
I'd like this node.

If unavailable,

another node is okay.
```

Unlike Required Affinity,

Pods never become Pending just because the preference cannot be satisfied.

---

### Weights

Preferred affinity supports weights.

Example:

```yaml
preferredDuringSchedulingIgnoredDuringExecution:
- weight: 80
  preference:
    ...

- weight: 20
  preference:
    ...
```

Scheduler assigns scores.

```
Node A

80 + 20 = 100

Node B

80

Node C

20
```

Highest score wins.

Weight simply adds preference.

It does **not** force scheduling.

---

## Operators

Node Affinity supports several operators.

| Operator | Meaning |
|-----------|----------|
| In | Value must exist in the list |
| NotIn | Value must NOT exist |
| Exists | Label exists |
| DoesNotExist | Label absent |
| Gt | Greater than |
| Lt | Less than |

---

## Node Selector vs Node Affinity

| Feature | Node Selector | Node Affinity |
|----------|---------------|---------------|
| Exact Match | ✅ | ✅ |
| Required Rules | ❌ | ✅ |
| Preferred Rules | ❌ | ✅ |
| Multiple Operators | ❌ | ✅ |
| Weighted Preferences | ❌ | ✅ |

---

# 3. Taints & Tolerations

Until now,

Pods were selecting Nodes.

Now,

Nodes start rejecting Pods.

This is the biggest mindset shift.

```
Node Selector

Pod chooses Node

---------------------

Taints

Node rejects Pods
```

---

# Taint

A Taint is applied on a Node.

Example:

```bash
kubectl taint node multinode-worker2 dedicated=database:NoSchedule
```

Format:

```
key=value:effect
```

Example:

```
dedicated=database:NoSchedule
```

Meaning:

```
Dedicated Database Node

↓

Don't schedule normal Pods here.
```

---

# Toleration

A Toleration is applied on the Pod.

Example:

```yaml
tolerations:
- key: dedicated
  operator: Equal
  value: database
  effect: NoSchedule
```

Meaning:

```
Pod says

"I'm allowed onto this node."
```

Important:

A Toleration **does not force scheduling**.

It simply removes the restriction.

The scheduler still decides where the Pod runs.

---

# Taint Effects

Kubernetes supports three effects.

---

## NoSchedule

```
Strict Rule
```

Node says:

```
No new Pods allowed.
```

Without matching toleration:

```
Pending
```

Existing Pods continue running.

---

## PreferNoSchedule

Soft rule.

```
Please avoid scheduling Pods here.
```

Scheduler tries to avoid the node.

If no better option exists,

Pods may still run there.

---

## NoExecute

Strongest effect.

```
No new Pods

+

Evict existing Pods
```

This is commonly used during:

- Node failures
- Maintenance
- Unreachable nodes

---

# tolerationSeconds

Supported only with:

```
NoExecute
```

Example:

```yaml
tolerations:
- key: dedicated
  value: database
  effect: NoExecute
  tolerationSeconds: 30
```

Meaning:

```
Pod may stay

30 seconds

↓

Evicted
```

Without `tolerationSeconds`,

Pod tolerates the taint indefinitely.

---

# Default Kubernetes NoExecute Tolerations

Every Pod automatically gets:

```
node.kubernetes.io/not-ready

node.kubernetes.io/unreachable
```

Both include:

```
300 seconds
```

This prevents unnecessary Pod eviction during temporary node failures.

---

# Scheduling Flow Summary

```
Node Selector

Pod
 │
 ▼
"I want THIS node."

------------------------

Node Affinity

Pod
 │
 ▼
"I REQUIRE or PREFER this node."

------------------------

Taint

Node
 │
 ▼
"I don't want Pods."

------------------------

Toleration

Pod
 │
 ▼
"I'm allowed onto this node."
```

---

# Quick Comparison

| Feature | Node Selector | Node Affinity | Taints |
|----------|---------------|---------------|---------|
| Controls Scheduling | Pod | Pod | Node |
| Exact Match | ✅ | ✅ | ❌ |
| Preferences | ❌ | ✅ | Soft (PreferNoSchedule) |
| Reject Pods | ❌ | ❌ | ✅ |
| Evict Running Pods | ❌ | ❌ | ✅ (NoExecute) |

---

# Commands Used

Label Node

```bash
kubectl label node <node-name> workload=frontend
```

Remove Label

```bash
kubectl label node <node-name> workload-
```

View Labels

```bash
kubectl get nodes --show-labels
```

Apply Taint

```bash
kubectl taint node <node-name> dedicated=database:NoSchedule
```

Remove Taint

```bash
kubectl taint node <node-name> dedicated=database:NoSchedule-
```

View Taints

```bash
kubectl describe node <node-name>
```

Describe Pod

```bash
kubectl describe pod <pod-name>
```

---

# Interview Takeaways

- Node Selector performs exact label matching.
- Node Affinity provides advanced scheduling rules.
- Required Affinity is mandatory; Preferred Affinity is only a preference.
- `IgnoredDuringExecution` means scheduling rules are not re-evaluated after the Pod starts.
- Taints are applied on Nodes; Tolerations are applied on Pods.
- A Toleration does **not** guarantee scheduling onto a tainted node.
- `NoSchedule` blocks new Pods.
- `PreferNoSchedule` discourages scheduling but does not block it.
- `NoExecute` blocks new Pods and evicts existing Pods without a matching toleration.
- `tolerationSeconds` provides a temporary grace period before eviction and is supported only with `NoExecute`.

---

# Conclusion

Scheduling is one of Kubernetes' core capabilities.

It enables workload isolation, resource optimization, fault tolerance, and production-grade cluster management.

Understanding Node Selectors, Node Affinity, and Taints & Tolerations provides the foundation for designing efficient and resilient Kubernetes workloads.
