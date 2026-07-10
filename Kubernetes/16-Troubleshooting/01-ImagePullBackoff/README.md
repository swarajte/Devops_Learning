# Kubernetes Troubleshooting - ImagePullBackOff 🚨

## 📅 Date

10 July 2026

---

# 🎯 Goal

Understand and troubleshoot:

- `ErrImagePull`
- `ImagePullBackOff`
- Private Docker Images
- `imagePullSecrets`

---

# 🧠 What is ImagePullBackOff?

`ImagePullBackOff` means Kubernetes failed to pull the container image and keeps retrying with increasing delays (BackOff).

Typical flow:

```text
ContainerCreating
      │
      ▼
ErrImagePull
      │
      ▼
ImagePullBackOff
```

---

# 🧠 Common Causes

- Wrong image name
- Wrong image tag
- Private repository
- Invalid registry credentials
- Registry/network issues

---

# 🧠 Troubleshooting Commands

### Watch Pod Status

```bash
kubectl get pods -w
```

### Describe Pod (Most Important)

```bash
kubectl describe pod <pod-name>
```

Always check the **Events** section for the actual error.

---

# 🧠 Hands-on Scenarios

## 1️⃣ Incorrect Image

File:

```text
nginx-deployment_incorrect_image.yaml
```

Result:

```text
ErrImagePull
↓

ImagePullBackOff
```

Reason:

Image name/tag does not exist.

---

## 2️⃣ Private Image Without Authentication

File:

```text
nginx-deployment_unauthorized.yaml
```

Result:

```text
ErrImagePull
↓

ImagePullBackOff
```

Reason:

Docker Hub denied access because the repository is private.

---

## 3️⃣ Private Image With imagePullSecret

File:

```text
nginx-deployment_authorized.yaml
```

Created Docker Registry Secret:

```bash
kubectl create secret docker-registry swaraj-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=<username> \
  --docker-password=<password> \
  --namespace=default
```

Added to Deployment:

```yaml
imagePullSecrets:
- name: swaraj-secret
```

Applied Deployment:

```bash
kubectl apply -f nginx-deployment_authorized.yaml
```

Verified:

```bash
kubectl get deployments
kubectl get pods
```

Result:

```text
READY 3/3
Pods Running Successfully
```

---

# 🧠 Useful Commands Used

```bash
kubectl apply -f <file>

kubectl get deployments

kubectl get pods

kubectl get pods -w

kubectl describe pod <pod-name>

kubectl get secrets

kubectl create secret docker-registry swaraj-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=<username> \
  --docker-password=<password> \
  --namespace=default
```

---

# 💡 Key Takeaways

- `ErrImagePull` = First image pull failed.
- `ImagePullBackOff` = Kubernetes keeps retrying with exponential backoff.
- `kubectl describe pod` is the first command to troubleshoot.
- `imagePullSecrets` are required for pulling images from private registries.
- Always verify:
  - Image name
  - Image tag
  - Repository visibility (Public/Private)
  - Registry credentials
````
