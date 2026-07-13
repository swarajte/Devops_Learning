# Kubernetes Troubleshooting - CrashLoopBackOff

## 📅 Date

13 July 2026

---

# Goal

Understand the different reasons that can cause `CrashLoopBackOff`.

---

# What is CrashLoopBackOff?

`CrashLoopBackOff` means a container repeatedly starts, terminates, and Kubernetes keeps restarting it with increasing delays (BackOff).

---

# Root Causes Covered

## 1. Wrong Startup Command

File:

```
01-wrong-cmd-crashloop.yml
```

Example:

```dockerfile
CMD python3 app1.py
```

Since `app1.py` did not exist:

- Container started
- Application exited
- Kubernetes restarted the container
- Result: `CrashLoopBackOff`

---

## 2. Liveness Probe Failure

File:

```
02-livenessprobe-crashloop.yml
```

Configured:

```yaml
livenessProbe:
  exec:
    command:
      - cat
      - /tmp/healthy
```

Since `/tmp/healthy` did not exist:

- Application started successfully.
- Liveness Probe failed.
- Kubernetes killed the container.
- Continuous restarts resulted in `CrashLoopBackOff`.

---

## 3. Out Of Memory (OOMKilled)

File:

```
03-out-of-memory-crashloop.yml
```

Configured:

```yaml
resources:
  limits:
    memory: "25Mi"
```

The application exceeded the memory limit.

Linux OOM Killer terminated the process.

Kubernetes restarted the Pod, eventually resulting in `CrashLoopBackOff`.

---

# Troubleshooting Commands

```bash
kubectl get pods -w

kubectl describe pod <pod-name>

kubectl logs <pod-name>

kubectl logs <pod-name> --previous
```

---

# Common Root Causes

- Wrong CMD / ENTRYPOINT
- Application exceptions
- Liveness Probe failures
- Startup Probe failures
- OOMKilled
- Missing configuration
- Database connection failures

---

# Key Learning

`CrashLoopBackOff` is **not the root cause**.

It is only a symptom indicating that the container keeps terminating and Kubernetes is backing off before restarting it again.

The real troubleshooting task is to determine **why** the container keeps terminating.
