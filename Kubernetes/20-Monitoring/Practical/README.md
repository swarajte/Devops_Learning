# Kubernetes Monitoring - Practical

## Date

19 July 2026

---

# Installed Components

- Prometheus
- Alertmanager
- node-exporter
- kube-state-metrics
- Pushgateway
- Grafana

---

# Important Commands

## Install Prometheus

```bash
helm install prometheus prometheus-community/prometheus
```

---

## Check Pods

```bash
kubectl get pods
```

---

## Check Services

```bash
kubectl get svc
```

---

## Expose Prometheus

```bash
kubectl expose service prometheus-server \
--type=NodePort \
--target-port=9090 \
--name=prometheus-server-ext
```

---

## Port Forward

Prometheus

```bash
kubectl port-forward svc/prometheus-server 9090:80
```

Grafana

```bash
kubectl port-forward svc/grafana 3000:80
```

---

## SSH Tunnel (Windows → POC)

```bash
ssh \
-L 9090:127.0.0.1:9090 \
-L 3000:127.0.0.1:3000 \
docker@ilcepoc3638
```

---

## URLs

Prometheus

```
http://127.0.0.1:9090
```

Grafana

```
http://127.0.0.1:3000
```

---

## Useful PromQL Queries

```
up

count(up)

prometheus_build_info

kube_pod_info

kube_node_info

node_memory_MemAvailable_bytes

node_cpu_seconds_total
```

---

# Troubleshooting Faced

## ImagePullBackOff

Problem:

```
x509 certificate signed by unknown authority
```

Cause:

Unable to pull image from registry.k8s.io.

Solution:

Imported image manually into containerd.

---

## Grafana Data Source

Problem:

```
localhost:9090
```

did not work.

Reason:

Grafana runs inside Kubernetes.

Correct URL:

```
http://prometheus-server
```

---

## Browser Access

Prometheus/Grafana were running on the remote Kubernetes cluster.

Needed:

- kubectl port-forward
- SSH Tunnel

to access them from the local laptop.
