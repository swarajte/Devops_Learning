# HPA Hands-on

## 1. Install Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

---

## 2. Verify Installation

```bash
kubectl get pods -n kube-system | grep metrics

kubectl get apiservices | grep metrics
```

---

## 3. Fix TLS Issue (Lab Environment)

Edit Metrics Server:

```bash
kubectl edit deployment metrics-server -n kube-system
```

Add:

```yaml
- --kubelet-insecure-tls
```

Restart:

```bash
kubectl rollout status deployment metrics-server -n kube-system
```

Verify:

```bash
kubectl top nodes

kubectl top pods
```

---

## 4. Create PHP Apache Deployment

```bash
kubectl apply -f php-apache.yaml
```

Verify:

```bash
kubectl get deployment

kubectl get pods
```

---

## 5. Expose Deployment

```bash
kubectl expose deployment php-apache --port=80
```

Verify:

```bash
kubectl get svc
```

---

## 6. Create HPA

```bash
kubectl autoscale deployment php-apache \
  --cpu-percent=50 \
  --min=1 \
  --max=10
```

Verify:

```bash
kubectl get hpa
```

---

## 7. Monitor Scaling

Terminal 1

```bash
kubectl get hpa -w
```

Terminal 2

```bash
kubectl get deployment -w
```

Terminal 3

```bash
kubectl get pods -w
```

---

## 8. Generate Load

Create BusyBox Pod:

```bash
kubectl run -it --rm load-generator --image=busybox -- /bin/sh
```

Inside BusyBox:

```sh
while true; do
    wget -q -O- http://php-apache;
done
```

---

## 9. Observe Scaling

Example:

```
CPU

18%

↓

250%

↓

190%

↓

73%

↓

41%
```

Pods:

```
1

↓

4

↓

5

↓

6
```

Stop the BusyBox loop:

```
Ctrl + C
```

Wait a few minutes and observe Pods automatically scaling back down.

---

## Commands Used

```bash
kubectl top nodes

kubectl top pods

kubectl get hpa

kubectl get deployment

kubectl get pods

kubectl get svc

kubectl describe hpa php-apache
```

---

## Files Created

```
deployment.yaml
php-apache.yaml
README.md
handson.md
```
