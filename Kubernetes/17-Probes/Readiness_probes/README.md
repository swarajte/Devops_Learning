# Readiness Probe

## Goal

Understand how Kubernetes decides whether a Pod should receive traffic.

---

## Demo

Configured:

```yaml
readinessProbe:
  exec:
    command:
      - cat
      - /tmp/ready
```

Since `/tmp/ready` did not exist, the readiness check failed.

---

## Observations

- Pod remained in `Running` state.
- READY showed `0/1`.
- Restart count remained `0`.
- Service removed the Pod from its endpoints.
- No traffic was routed to the Pod.

---

## Commands Used

```bash
kubectl apply -f readiness-probe.yaml

kubectl apply -f service.yaml

kubectl get pods -w

kubectl describe pod <pod-name>

kubectl get endpoints

kubectl delete -f readiness-probe.yaml
```

---

## Key Learning

Readiness Probe does not restart containers.

It only controls whether a Pod should receive traffic from a Service.
