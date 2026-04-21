# Kubernetes Hands-on (Minikube) - Learning Summary 🚀

## 📅 Date

21 April 2026

---

## 🎯 Goal

Understand basic Kubernetes objects and interact with a local cluster using Minikube.

---

## ⚙️ Setup

* Verified **Minikube** installation
* Used existing **kubectl (Docker version)**
* Started local cluster:

```bash
minikube start
```

---

## 🧠 Core Concepts Learned

### 🔹 Pod

* Smallest unit in Kubernetes
* Runs one or more containers
* Gets its own IP

---

### 🔹 Pod IP

* Each Pod gets a unique IP (e.g., `10.244.x.x`)
* Containers inside Pod share same IP
* Used for internal communication

---

### 🔹 Node

* Machine where Pods run
* In Minikube → single node cluster

---

### 🔹 Logs

* Output of container (like app logs)
* Used for debugging

---

## 🔧 Commands Practiced

### Pod Management

```bash
kubectl get pods                 # List pods
kubectl create -f simple-pod.yaml  # Create pod using YAML
kubectl get pods -o wide         # Detailed pod info (IP, node)
```

---

### Node Inspection

```bash
kubectl get nodes               # List nodes
kubectl describe nodes minikube # Detailed node info
```

---

### Debugging

```bash
kubectl describe pod nginx      # Full pod details
kubectl logs nginx              # View container logs
```

---

## 🔍 Observations

* Pod `nginx` successfully created and running
* Pod assigned IP: `10.244.0.4`
* Running on node: `minikube`
* Container image: `nginx:1.14.2`

---

## ⚠️ Important Learnings

* Pod IP ≠ stable (changes on restart)
* Containers inside Pod share same network (localhost)
* `kubectl logs` is essential for debugging
* `-o wide` helps understand where Pod is running

---

## 🧠 Key Takeaway

> Kubernetes runs applications inside Pods, assigns them IPs, and manages them on Nodes.

---

