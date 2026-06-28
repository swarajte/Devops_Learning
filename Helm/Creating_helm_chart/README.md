# 12 - Creating Your Own Helm Repository 🚀

## 📅 Date

28 June 2026

---

# 🎯 Goal

Learn:

* Helm Chart Structure
* Chart.yaml
* values.yaml
* templates/
* Packaging Helm Charts
* Creating a Helm Repository
* Understanding `index.yaml`

---

# 🧠 Helm Chart Structure

Created two Helm Charts:

```text
payments/

shipping/
```

Each chart contains:

```text
payments/

├── Chart.yaml
├── values.yaml
├── templates/
├── charts/
└── .helmignore
```

---

# 🧠 Chart.yaml

`Chart.yaml` contains metadata about the Helm Chart.

Example information:

* Chart Name
* Version
* Description
* Application Version

Think:

```text
Chart.yaml
      ↓
Identity Card of the Chart
```

Example:

```yaml
name: payments
version: 0.1.0
description: Payment Service
```

---

# 🧠 values.yaml

`values.yaml` stores the configurable values used by the chart.

Examples:

* Replica Count
* Docker Image
* Service Port
* Resource Limits

Think:

```text
values.yaml
      ↓
Settings File
```

Instead of hardcoding values inside Kubernetes YAMLs, Helm reads them from this file.

Example:

```yaml
replicaCount: 2

image:
  repository: nginx
```

---

# 🧠 templates/

The `templates/` directory contains Kubernetes manifest templates.

Examples:

* deployment.yaml
* service.yaml
* ingress.yaml
* serviceaccount.yaml

Instead of fixed values:

```yaml
replicas: 2
```

Helm uses placeholders:

```yaml
replicas: {{ .Values.replicaCount }}
```

During installation, Helm replaces placeholders using values from `values.yaml`.

Think:

```text
templates/
      ↓
Blueprints with Variables
```

---

# 🧠 Relationship Between values.yaml and templates/

```text
values.yaml
        ↓
Contains Configuration

templates/
        ↓
Uses Configuration

Helm
        ↓
Replaces Variables

Final Kubernetes YAML
        ↓
Sent to Kubernetes API Server
```

---

# 🧠 Packaging a Helm Chart

Created packaged charts using:

```bash
helm package payments

helm package shipping
```

Generated:

```text
payments-0.1.0.tgz

shipping-0.1.0.tgz
```

Think:

```text
Chart Folder
        ↓
helm package
        ↓
Compressed Chart (.tgz)
```

The `.tgz` file is the distributable version of a Helm Chart.

---

# 🧠 Creating a Helm Repository

Created repository index:

```bash
helm repo index .
```

Generated:

```text
index.yaml
```

---

# 🧠 What is index.yaml?

`index.yaml` is the catalogue of a Helm Repository.

It contains:

* Chart Name
* Chart Version
* Description
* Download URL
* Digest (Checksum)

Helm uses this file to discover available charts.

Think:

```text
Helm Repository
       ↓
App Store

index.yaml
       ↓
Catalogue

payments-0.1.0.tgz
shipping-0.1.0.tgz
       ↓
Applications
```

---

# 🧠 How a Helm Repository Works

Suppose this folder is hosted:

```text
best-commerce/

├── index.yaml
├── payments-0.1.0.tgz
└── shipping-0.1.0.tgz
```

Add Repository:

```bash
helm repo add best-commerce https://mycompany.github.io/best-commerce
```

Internally:

```text
Helm
      ↓
Downloads index.yaml
      ↓
Reads Available Charts
      ↓
Displays Search Results
      ↓
Downloads Required .tgz
      ↓
Installs Chart
```

---

# 🧠 Complete Flow

```text
Chart Folder
      ↓
helm package
      ↓
Chart Package (.tgz)
      ↓
helm repo index
      ↓
index.yaml
      ↓
Host Repository
      ↓
helm repo add
      ↓
helm search repo
      ↓
helm install
```

---

# 🧠 Linux (APT) vs Helm

| Linux (APT)         | Kubernetes (Helm) |
| ------------------- | ----------------- |
| Repository          | Helm Repository   |
| Package (.deb/.rpm) | Chart (.tgz)      |
| Package Index       | index.yaml        |
| apt install         | helm install      |
| Installed Software  | Helm Release      |

---

# 🧠 Hands-On Performed

Created Helm Charts:

```bash
helm create payments

helm create shipping
```

Packaged Charts:

```bash
helm package payments

helm package shipping
```

Generated:

```text
payments-0.1.0.tgz

shipping-0.1.0.tgz
```

Created Repository Index:

```bash
helm repo index .
```

Generated:

```text
index.yaml
```

Verified:

```bash
cat index.yaml
```

Observed:

* payments chart
* shipping chart
* versions
* package URLs
* digests

---

# 🎯 Final Understanding

```text
Chart.yaml
      ↓
Chart Information

values.yaml
      ↓
Configuration

templates/
      ↓
Kubernetes Templates

helm package
      ↓
Chart Package (.tgz)

helm repo index
      ↓
Repository Catalogue (index.yaml)

Host Folder
      ↓
Helm Repository

helm repo add
      ↓
Repository Added

helm search repo
      ↓
Search Available Charts

helm install
      ↓
Download Chart

Render Templates

Create Kubernetes Resources

Application Running
```

---

# 💡 One-Line Summary

A Helm Chart is a reusable package of Kubernetes manifests. It is packaged into a `.tgz` file, indexed using `index.yaml`, hosted as a Helm Repository, and then downloaded and installed by Helm to deploy applications into a Kubernetes cluster.

