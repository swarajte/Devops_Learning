# 11 - Helm Basics 🚀

## 📅 Date

22 June 2026

---

# 🎯 Goal

Learn:

* What Helm is
* Why Helm is used
* Helm Repository
* Helm Chart
* Helm Release
* Basic Helm Commands
* Installing applications using Helm

---

# 🧠 What is Helm?

Helm is the **Package Manager for Kubernetes**.

Just like Linux uses:

```text
APT → Installs Linux Packages
```

Kubernetes uses:

```text
Helm → Installs Kubernetes Applications
```

Helm simplifies deploying and managing applications inside Kubernetes.

---

# 🧠 Why Helm?

Without Helm:

Deploying an application may require manually creating:

* Deployment
* Service
* ConfigMap
* Secret
* Ingress
* PVC
* RBAC

using multiple YAML files.

With Helm:

```bash
helm install <release-name> <repo/chart>
```

Helm automatically creates all required Kubernetes resources.

---

# 🧠 Linux (APT) vs Helm

| Linux (APT)        | Kubernetes (Helm) |
| ------------------ | ----------------- |
| Repository         | Repository        |
| Package            | Chart             |
| apt install        | helm install      |
| Installed Software | Release           |

---

# 🧠 Helm Repository

A Helm Repository is a storage location that contains Helm Charts.

Examples:

* Bitnami Repository
* AWS EKS Repository
* Prometheus Community Repository

Think:

```text
Repository = App Store
```

It stores charts that can be downloaded and installed.

---

# 🧠 Helm Chart

A Helm Chart is a packaged collection of Kubernetes manifests.

A chart may contain:

* Deployment
* Service
* ConfigMap
* Secret
* Ingress
* PVC
* RBAC

Think:

```text
Chart = Package of Kubernetes Resources
```

Example:

```text
bitnami/nginx
```

contains everything required to deploy nginx inside Kubernetes.

---

# 🧠 Helm Release

A Release is an installed instance of a Helm Chart.

Example:

Chart:

```text
bitnami/nginx
```

Install:

```bash
helm install my-nginx bitnami/nginx
```

Release:

```text
my-nginx
```

One Chart can create multiple Releases.

Example:

```text
bitnami/nginx

↓

dev-nginx

test-nginx

prod-nginx
```

Releases help Helm:

* Track installed resources
* Upgrade applications
* Rollback applications
* Uninstall applications

Think:

```text
Chart = Blueprint

Release = Installed Copy
```

---

# 🧠 What Happens During helm install?

Command:

```bash
helm install my-nginx bitnami/nginx
```

Flow:

```text
Helm Repository
        ↓
Download Chart
        ↓
Generate Kubernetes YAML
        ↓
Send YAML to API Server
        ↓
Deployment Created
        ↓
ReplicaSet Created
        ↓
Pod Created
        ↓
Nginx Container Running
```

Helm itself does **not** run the application.

It creates Kubernetes resources, and Kubernetes runs the application.

---

# 🧠 Pod Created After Installation

After installing:

```bash
helm install my-nginx bitnami/nginx
```

Observed Pod:

```text
my-nginx-54c87d4856-kp42k
```

Understanding:

```text
Helm Chart
      ↓
Deployment
      ↓
ReplicaSet
      ↓
Pod
      ↓
Container
      ↓
Nginx Process
```

The Pod contains an nginx container, which runs the nginx process.

---

# 🧠 kubectl exec Breakdown

Command:

```bash
kubectl exec -it my-nginx-54c87d4856-kp42k -- /bin/sh
```

Breakdown:

```text
kubectl
↓

Talk to Kubernetes

exec
↓

Execute command inside running container

-it
↓

Interactive Terminal

my-nginx-54c87d4856-kp42k
↓

Target Pod

--
↓

Everything after this runs inside container

/bin/sh
↓

Open shell inside container
```

---

# 🧠 Hands-On Performed

### Added Bitnami Repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

---

### Searched Available Charts

```bash
helm search repo bitnami

helm search repo bitnami | grep nginx

helm search repo bitnami | grep prometheus
```

---

### Added AWS Repository

```bash
helm repo add eks https://aws.github.io/eks-charts
```

---

### Searched AWS Charts

```bash
helm search repo eks

helm search repo eks | grep -i aws

helm search repo eks | grep -i alb

helm search repo eks | grep -i load
```

---

### Installed Nginx Chart

```bash
helm install my-nginx bitnami/nginx
```

---

### Verified Running Pod

```bash
kubectl get pods
```

Observed:

```text
my-nginx-54c87d4856-kp42k
```

---

### Connected to Running Container

```bash
kubectl exec -it my-nginx-54c87d4856-kp42k -- /bin/sh
```

---

### Listed Installed Releases

```bash
helm list
```

---

### Uninstalled Release

```bash
helm uninstall prod-nginx
```

---

# 🧠 Useful Commands Learned

```bash
helm version

helm repo add

helm search repo

helm install

helm list

helm uninstall

kubectl get pods

kubectl exec -it <pod> -- /bin/sh

kubectl get deployments --sort-by=.metadata.creationTimestamp | tac
```

---

# 🎯 Final Understanding

```text
Repository
      ↓
Stores Charts

Chart
      ↓
Package of Kubernetes Resources

helm install
      ↓
Creates Release

Release
      ↓
Creates Kubernetes Resources

Deployment
      ↓
ReplicaSet
      ↓
Pod
      ↓
Container
      ↓
Application Running
```

---

# 💡 One-Line Summary

Helm is the package manager for Kubernetes. It downloads Charts from Repositories, creates Releases, and deploys all the Kubernetes resources required to run an application inside a cluster.

