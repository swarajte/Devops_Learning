# Kubernetes Probes

## 📅 Date

13 July 2026

---

# What are Probes?

Probes are health checks performed by Kubernetes to determine the state of a container.

Kubernetes supports three types of probes:

- Startup Probe
- Liveness Probe
- Readiness Probe

---

# Startup Probe

## Purpose

Checks whether the application has finished starting.

Until the Startup Probe succeeds:

- Liveness Probe does not run.
- Readiness Probe does not run.

If Startup Probe keeps failing, Kubernetes restarts the container.

### Common Use Cases

- Spring Boot
- Kafka
- Elasticsearch
- Slow-starting applications

### Sample Configuration

```yaml
startupProbe:
  exec:
    command:
      - cat
      - /tmp/started
```

---

# Liveness Probe

## Purpose

Checks whether the application is still healthy after startup.

If the probe fails repeatedly:

- Kubernetes kills the container.
- A new container is started.

### Sample Configuration

```yaml
livenessProbe:
  exec:
    command:
      - cat
      - /tmp/healthy
```

---

# Readiness Probe

## Purpose

Checks whether the application is ready to receive traffic.

If the probe fails:

- Container continues running.
- Pod is removed from Service endpoints.
- No traffic is sent to the Pod.

### Sample Configuration

```yaml
readinessProbe:
  exec:
    command:
      - cat
      - /tmp/ready
```

---

# Commands Used

```bash
kubectl apply -f <file>.yaml

kubectl get pods -w

kubectl describe pod <pod-name>

kubectl get services

kubectl get endpoints

kubectl delete -f <file>.yaml
```

---

# Difference Between Probes

| Probe | Question | Failure Action |
|--------|----------|----------------|
| Startup | Has the application finished starting? | Restart container if startup never completes |
| Liveness | Is the application still healthy? | Restart container |
| Readiness | Can this Pod receive traffic? | Remove Pod from Service endpoints |

---

# Key Learnings

- Startup Probe protects slow-starting applications.
- Liveness Probe provides automatic self-healing.
- Readiness Probe controls traffic without restarting containers.
- A failed Readiness Probe does **not** restart the Pod.
- A failed Liveness or Startup Probe can eventually lead to `CrashLoopBackOff`.
