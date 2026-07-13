# Liveness Probe

## Goal

Understand Kubernetes self-healing using Liveness Probes.

---

## Demo

Configured:

```yaml
livenessProbe:
  exec:
    command:
      - cat
      - /tmp/healthy
```

Since `/tmp/healthy` did not exist, every health check failed.

---

## Observations

- Container started successfully.
- Liveness Probe failed.
- Kubernetes killed the container.
- Deployment recreated the container.
- Repeated failures resulted in `CrashLoopBackOff`.

---

## Commands Used

```bash
kubectl apply -f liveness-probe.yaml

kubectl get pods -w

kubectl describe pod <pod-name>

kubectl delete -f liveness-probe.yaml
```

---

## Key Learning

Liveness Probe checks application health after startup.

If the application becomes unhealthy, Kubernetes automatically restarts the container.
