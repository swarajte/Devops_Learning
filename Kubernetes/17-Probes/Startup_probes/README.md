# Startup Probe

## Goal

Understand how Kubernetes handles slow-starting applications.

---

## Demo

Configured a Startup Probe using:

```yaml
startupProbe:
  exec:
    command:
      - cat
      - /tmp/started
```

Since `/tmp/started` does not exist, the probe continuously failed.

---

## Observations

- Pod started successfully.
- Startup Probe failed repeatedly.
- Kubernetes waited based on:
  - `periodSeconds`
  - `failureThreshold`
- After multiple failures, Kubernetes restarted the container.
- Eventually the Pod entered `CrashLoopBackOff`.

---

## Commands Used

```bash
kubectl apply -f startup-probe.yaml

kubectl get pods -w

kubectl describe pod <pod-name>

kubectl delete -f startup-probe.yaml
```

---

## Key Learning

Startup Probe is only responsible for startup.

Once it succeeds once, it never runs again and Kubernetes enables:

- Liveness Probe
- Readiness Probe
